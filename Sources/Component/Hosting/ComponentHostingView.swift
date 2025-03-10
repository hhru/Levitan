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

    private let hostingController: HostingController

    private var content: Content?
    private var context: ComponentContext?

    private let fallbackComponentViewCache = FallbackComponentViewCache()

    public override init(frame: CGRect = .zero) {
        let hostingRoot = HostingRoot(
            content: nil,
            context: nil
        )

        hostingController = HostingController(rootView: hostingRoot)

        super.init(frame: frame)

        tokens.customBinding { view, _ in
            view.updateHostingController()
        }
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupHostingControllerIfNeeded() {
        guard let context, let superview else {
            return
        }

        let nextViewController = context.componentViewController ?? superview.next(of: UIViewController.self)

        let hasParentViewController = nextViewController.map { viewController in
            viewController is UINavigationController
                || viewController is UITabBarController
                || viewController is UISplitViewController
        } == false

        let parentViewController = hasParentViewController
            ? nextViewController
            : nil

        if hostingController.parent != parentViewController {
            resetHostingControllerIfNeeded()
        }

        guard hostingController.view.superview == nil else {
            return
        }

        hostingController.view.frame = bounds
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

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

    private func resetHostingControllerIfNeeded() {
        guard hostingController.viewIfLoaded?.superview != nil else {
            return
        }

        hostingController.willMove(toParent: nil)
        hostingController.view.removeFromSuperview()
        hostingController.removeFromParent()
    }

    private func layoutHostingControllerIfNeeded() {
        guard window != nil else {
            return
        }

        hostingController.view.setNeedsLayout()
        hostingController.view.layoutIfNeeded()
        hostingController.view.invalidateIntrinsicContentSize()
    }

    private func updateHostingController() {
        let content = window == nil
            ? nil
            : content

        let context = window == nil
            ? nil
            : context

        let contentContext = context?
            .fallbackComponentViewCache(fallbackComponentViewCache)
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

        updateHostingController()

        if hostingController.viewIfLoaded?.superview != nil {
            layoutHostingControllerIfNeeded()
        }
    }
}

extension ComponentHostingView: ComponentView {

    public func update(with content: Content, context: ComponentContext) {
        self.context = context
        self.content = content

        if window != nil {
            updateHostingController()
        }

        if hostingController.viewIfLoaded?.superview == nil {
            setupHostingControllerIfNeeded()
        } else {
            layoutHostingControllerIfNeeded()
        }
    }
}
#endif
