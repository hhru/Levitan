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
public final class ComponentHostingView<Content: Component>: UIView {

    private typealias HostingRoot = ComponentHostingRoot<Content>
    private typealias HostingController = ComponentHostingController<HostingRoot>

    private weak var viewController: UIViewController?

    private let hostingController: HostingController

    public override init(frame: CGRect = .zero) {
        let hostingRoot = HostingRoot(
            content: nil,
            context: nil
        )

        hostingController = HostingController(rootView: hostingRoot)

        super.init(frame: frame)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layoutHostingController() {
        hostingController.view.setNeedsLayout()
        hostingController.view.layoutIfNeeded()

        hostingController.view.invalidateIntrinsicContentSize()
    }

    private func setupHostingControllerIfNeeded(window: UIWindow?) {
        resetHostingControllerIfNeeded()

        guard let superview, window != nil else {
            return
        }

        guard let viewController = viewController ?? superview.next(of: UIViewController.self) else {
            return
        }

        let shouldIgnoreParentViewController = viewController is UINavigationController
            || viewController is UITabBarController
            || viewController is UISplitViewController

        hostingController.view.frame = bounds
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        if !shouldIgnoreParentViewController {
            viewController.addChild(hostingController)
        }

        addSubview(hostingController.view)

        let constraints = [
            hostingController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: topAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]

        NSLayoutConstraint.activate(constraints)

        if !shouldIgnoreParentViewController {
            hostingController.didMove(toParent: viewController)
        }
    }

    private func resetHostingControllerIfNeeded() {
        guard hostingController.view.superview != nil else {
            return
        }

        hostingController.willMove(toParent: nil)
        hostingController.view.removeFromSuperview()
        hostingController.removeFromParent()
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        layoutHostingController()
    }

    public override func didMoveToWindow() {
        super.didMoveToWindow()

        if window == nil {
            resetHostingControllerIfNeeded()
        }
    }

    public override func willMove(toWindow window: UIWindow?) {
        super.willMove(toWindow: window)

        setupHostingControllerIfNeeded(window: window)
    }
}

extension ComponentHostingView: ComponentView {

    public func update(with content: Content, context: ComponentContext) {
        viewController = context.componentViewController

        let contentContext = context
            .componentViewController(hostingController)
            .componentLayoutInvalidation { [weak hostingController] in
                hostingController?.view.invalidateIntrinsicContentSize()
            }

        hostingController.rootView = HostingRoot(
            content: content,
            context: contentContext
        )

        if hostingController.view.superview == nil {
            setupHostingControllerIfNeeded(window: window)
        }
            
        layoutHostingController()
    }
}
