#if canImport(UIKit)
import UIKit
import SwiftUI

/// UIKit-представление для встраивания SwiftUI-компонентов.
///
/// Встраивает `UIHostingController` только после добавления в иерархию `UIWindow`,
/// чтобы гарантировать наличие экземпляра `UIViewController` в контексте или в цепочке `UIResponder`.
///
/// Также самостоятельно синхронизирует SwiftUI-окружение с переопределенными значениями в UIKit-представлениях.
///
/// - SeeAlso: ``Component``
/// - SeeAlso: ``ComponentView``
/// - SeeAlso: ``ComponentContext``
public final class ComponentHostingView<Content: View>: UIView {

    private typealias HostingRoot = ComponentHostingRoot<Content>
    private typealias HostingController = ComponentHostingController<HostingRoot>

    private var hostingController: HostingController?

    private var content: Content?
    private var context: ComponentContext?

    private var appearanceObserverToken: ComponentAppearanceObserverToken?
    private var appearanceState = false

    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)

        tokens.customBinding { view, _ in
            if let content = view.content, let context = view.context {
                view.updateHostingController(with: content, context: context)
            }
        }
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupHostingController(
        _ hostingController: HostingController,
        parentViewController: UIViewController?
    ) {
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.frame = bounds

        if let parentViewController {
            parentViewController.addChild(hostingController)
        }

        addSubview(hostingController.view)

        let constraints = [
            hostingController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: topAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]

        NSLayoutConstraint.activate(constraints)

        if let parentViewController {
            hostingController.didMove(toParent: parentViewController)
        }
    }

    private func setupHostingControllerIfNeeded(_ hostingController: HostingController) {
        self.hostingController = hostingController

        guard let context, let superview, window != nil, appearanceState else {
            return
        }

        let nearestViewController = context.componentViewController
            ?? superview.next(of: UIViewController.self)

        let shouldIgnoreParentViewController = nearestViewController.map { viewController in
            viewController is UINavigationController
                || viewController is UITabBarController
                || viewController is UISplitViewController
        } ?? true

        let parentViewController = shouldIgnoreParentViewController
            ? nil
            : nearestViewController

        if hostingController.view.superview != nil {
            if hostingController.parent === parentViewController {
                return
            }

            resetHostingController(hostingController)
        }

        setupHostingController(
            hostingController,
            parentViewController: parentViewController
        )
    }

    private func resetHostingController(_ hostingController: HostingController) {
        hostingController.beginAppearanceTransition(false, animated: false)

        if hostingController.parent == nil {
            hostingController.view.removeFromSuperview()
        } else {
            hostingController.willMove(toParent: nil)
            hostingController.view.removeFromSuperview()
            hostingController.removeFromParent()
        }

        hostingController.endAppearanceTransition()

        self.hostingController = nil
    }

    private func resetHostingControllerIfNeeded(_ hostingController: HostingController) {
        guard hostingController.viewIfLoaded?.superview != nil else {
            return
        }

        resetHostingController(hostingController)
    }

    private func layoutHostingController(_ hostingController: HostingController) {
        hostingController.view.invalidateIntrinsicContentSize()

        hostingController.view.setNeedsLayout()
        hostingController.view.layoutIfNeeded()
    }

    private func updateHostingController(_ hostingController: HostingController) {
        if hostingController.viewIfLoaded?.superview == nil {
            setupHostingControllerIfNeeded(hostingController)
        } else {
            layoutHostingController(hostingController)
        }
    }

    private func updateHostingController(with content: Content, context: ComponentContext) {
        let context = context
            .componentAppearanceObservatory(nil)
            .componentViewControllerProvider { [weak self] in
                self?.hostingController
            }
            .componentLayoutInvalidation { [weak self] in
                self?.hostingController?.view.invalidateIntrinsicContentSize()
            }

        if let hostingController {
            let componentIdentifier = hostingController
                .rootView
                .context?
                .componentIdentifier
                .value

            if let componentIdentifier, componentIdentifier != context.componentIdentifier {
                resetHostingControllerIfNeeded(hostingController)
            } else {
                hostingController.rootView = HostingRoot(
                    content: content,
                    context: context
                )

                return updateHostingController(hostingController)
            }
        }

        let rootView = HostingRoot(
            content: content,
            context: context
        )

        let hostingController = HostingController(rootView: rootView)

        setupHostingControllerIfNeeded(hostingController)
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()

        if let hostingController, superview == nil {
            resetHostingControllerIfNeeded(hostingController)
        } else if let content, let context {
            updateHostingController(with: content, context: context)
        }
    }

    public override func didMoveToWindow() {
        super.didMoveToWindow()

        if let hostingController, window == nil {
            resetHostingControllerIfNeeded(hostingController)
        } else if let content, let context {
            updateHostingController(with: content, context: context)
        }
    }
}

extension ComponentHostingView: ComponentView {

    public func update(with content: Content, context: ComponentContext) {
        self.context = context
        self.content = content

        appearanceObserverToken = context
            .componentAppearanceObservatory?
            .observe(by: self)

        appearanceState = appearanceObserverToken == nil

        updateHostingController(with: content, context: context)
    }
}

extension ComponentHostingView: ComponentAppearanceObserver {

    public func onAppear() {
        appearanceState = true

        if let hostingController {
            setupHostingControllerIfNeeded(hostingController)
        } else if let content, let context {
            updateHostingController(with: content, context: context)
        }
    }

    public func onDisappear() {
        appearanceState = false

        guard let hostingController else {
            return
        }

        resetHostingControllerIfNeeded(hostingController)
    }
}
#endif
