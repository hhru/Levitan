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

    private let appearance = ComponentAppearance()

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

    public override func didMoveToWindow() {
        super.didMoveToWindow()

        if window == nil {
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

        hostingController
            .view
            .leadingAnchor
            .constraint(equalTo: leadingAnchor)
            .activate()

        hostingController
            .view
            .topAnchor
            .constraint(equalTo: topAnchor)
            .activate()

        hostingController
            .view
            .trailingAnchor
            .constraint(equalTo: trailingAnchor)
            .priority(.almostRequired)
            .activate()

        hostingController
            .view
            .bottomAnchor
            .constraint(equalTo: bottomAnchor)
            .priority(.almostRequired)
            .activate()

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

    private func setupHostingControllerIfNeeded(
        with hostingRoot: HostingRoot,
        forced: Bool = false
    ) {
        guard let superview, window != nil, appearance.isExist || forced else {
            return
        }

        if let hostingController {
            return setupHostingControllerIfNeeded(
                hostingController,
                superview: superview
            )
        }

        let hostingController = HostingController(
            rootView: hostingRoot,
            intrinsicContentSizeInvalidation: { [weak self] in
                self?.invalidateIntrinsicContentSize()
            }
        )

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
        guard hostingController.viewIfLoaded?.superview != nil else {
            return
        }

        resetHostingController(hostingController)
    }

    private func updateHostingController(
        _ hostingController: HostingController,
        with hostingRoot: HostingRoot
    ) {
        hostingController.rootView = hostingRoot

        invalidateIntrinsicContentSize()

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
        let previousID = hostingRoot?.context.componentID.value
        let newID = context.componentID.value

        componentViewController = context.componentViewController

        let context = context
            .componentAppearance(appearance, of: self)
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
            if previousID == newID {
                updateHostingController(
                    hostingController,
                    with: hostingRoot
                )
            } else {
                self.hostingController = nil

                resetHostingControllerIfNeeded(hostingController)
            }
        }

        setupHostingControllerIfNeeded(
            with: hostingRoot,
            forced: true
        )
    }
}

extension ComponentHostingView: ComponentAppearanceView {

    public func onViewAppear() {
        guard let hostingRoot else {
            return
        }

        setupHostingControllerIfNeeded(with: hostingRoot)
    }

    public func onViewDisappear() {
        guard let hostingController else {
            return
        }

        resetHostingControllerIfNeeded(hostingController)
    }
}
#endif
