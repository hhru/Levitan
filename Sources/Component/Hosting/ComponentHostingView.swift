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

    private let hostingController: HostingController

    private var content: Content?
    private var context: ComponentContext?

    public override init(frame: CGRect = .zero) {
        let hostingRoot = HostingRoot(
            content: nil,
            context: nil
        )

        hostingController = HostingController(rootView: hostingRoot)

        super.init(frame: frame)

        tokens.customBinding { view, _ in
            if let content = view.content, let context = view.context {
                view.update(with: content, context: context)
            }
        }
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupHostingControllerIfNeeded() {
        resetHostingControllerIfNeeded()

        guard let content, let context, let superview, window != nil else {
            return
        }

        let viewController = context.componentViewController ?? superview.next(of: UIViewController.self)

        let shouldIgnoreParentViewController = viewController.map { viewController in
            viewController is UINavigationController
                || viewController is UITabBarController
                || viewController is UISplitViewController
        } ?? true

        hostingController.view.frame = bounds
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        if !shouldIgnoreParentViewController {
            viewController?.addChild(hostingController)
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

        updateHostingController(
            content: content,
            context: context
        )
    }

    private func resetHostingControllerIfNeeded() {
        guard hostingController.viewIfLoaded?.superview != nil else {
            return
        }

        hostingController.rootView = HostingRoot(
            content: nil,
            context: nil
        )

        hostingController.willMove(toParent: nil)
        hostingController.view.removeFromSuperview()
        hostingController.removeFromParent()
    }

    private func layoutHostingController() {
        hostingController.view.setNeedsLayout()
        hostingController.view.layoutIfNeeded()
        hostingController.view.invalidateIntrinsicContentSize()
    }

    private func updateHostingController(content: Content, context: ComponentContext) {
        let contentContext = context
            .componentViewController(hostingController)
            .componentLayoutInvalidation { [weak hostingController] in
                hostingController?.view.invalidateIntrinsicContentSize()
            }

        hostingController.rootView = HostingRoot(
            content: content,
            context: contentContext
        )
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()

        setupHostingControllerIfNeeded()
    }

    public override func didMoveToWindow() {
        super.didMoveToWindow()

        setupHostingControllerIfNeeded()
    }
}

extension ComponentHostingView: ComponentView {

    public func update(with content: Content, context: ComponentContext) {
        self.context = context
        self.content = content

        if hostingController.viewIfLoaded?.superview == nil {
            setupHostingControllerIfNeeded()
        } else {
            updateHostingController(
                content: content,
                context: context
            )

            layoutHostingController()
        }
    }
}
#endif
