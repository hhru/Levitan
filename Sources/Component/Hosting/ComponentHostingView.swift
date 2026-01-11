#if canImport(UIKit)
import UIKit
import SwiftUI

/// UIKit-представление для встраивания SwiftUI-компонентов.
///
/// Встраивает `UIHostingController` только после добавления в иерархию,
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
    private var hostingRoot: HostingRoot?

    private weak var componentViewController: UIViewController?

    public override var intrinsicContentSize: CGSize {
        hostingController?
            .viewIfLoaded?
            .intrinsicContentSize ?? super.intrinsicContentSize
    }

    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)

        tokens.customBinding { view, _ in
            view.updateHostingControllerIfNeeded()
        }
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()

        if superview == nil {
            if let hostingController {
                resetHostingControllerIfNeeded(hostingController)
            }
        } else if let hostingRoot {
            setupHostingControllerIfNeeded(with: hostingRoot)
        }
    }
}

extension ComponentHostingView {

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

        invalidateIntrinsicContentSize()
    }

    private func setupHostingControllerIfNeeded(
        _ hostingController: HostingController,
        superview: UIView
    ) {
        let nearestViewController = componentViewController
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

    private func setupHostingControllerIfNeeded(with hostingRoot: HostingRoot) {
        guard let superview else {
            return
        }

        if let hostingController {
            return setupHostingControllerIfNeeded(
                hostingController,
                superview: superview
            )
        }

        let hostingController = HostingController(rootView: hostingRoot)

        setupHostingControllerIfNeeded(
            hostingController,
            superview: superview
        )

        self.hostingController = hostingController
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
    }

    private func resetHostingControllerIfNeeded(_ hostingController: HostingController) {
        self.hostingController = nil

        guard hostingController.viewIfLoaded?.superview != nil else {
            return
        }

        resetHostingController(hostingController)
    }

    private func updateHostingController(
        _ hostingController: HostingController,
        with hostingRoot: HostingRoot
    ) {
        invalidateIntrinsicContentSize()

        hostingController.rootView = hostingRoot

        hostingController.view.invalidateIntrinsicContentSize()
        hostingController.view.setNeedsLayout()
        hostingController.view.layoutIfNeeded()
    }

    private func updateHostingControllerIfNeeded() {
        guard let hostingController, let hostingRoot else {
            return
        }

        updateHostingController(
            hostingController,
            with: hostingRoot
        )
    }
}

extension ComponentHostingView: ComponentView {

    public func update(with content: Content, context: ComponentContext) {
        componentViewController = context.componentViewController

        let context = context
            .componentViewControllerProvider { [weak self] in
                self?.hostingController
            }
            .componentLayoutInvalidation { [weak self] in
                self?.invalidateIntrinsicContentSize()

                self?
                    .hostingController?
                    .view
                    .invalidateIntrinsicContentSize()
            }

        let hostingRoot = HostingRoot(
            content: content,
            context: context
        )

        self.hostingRoot = hostingRoot

        if let hostingController {
            return updateHostingController(
                hostingController,
                with: hostingRoot
            )
        }

        setupHostingControllerIfNeeded(with: hostingRoot)
    }
}
#endif
