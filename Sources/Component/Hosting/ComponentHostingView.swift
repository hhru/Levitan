#if canImport(UIKit)
import UIKit
import SwiftUI

/// UIKit-представление для встраивания SwiftUI-компонентов.
///
/// - SeeAlso: ``Component``
/// - SeeAlso: ``ComponentView``
/// - SeeAlso: ``ComponentContext``
public final class ComponentHostingView<Content: View>: UIView {

    private typealias HostingRoot = ComponentHostingRoot<Content>
    private typealias HostingController = ComponentHostingController<HostingRoot>

    private var hostingController: HostingController?

    private weak var hostingControllerExplicitParent: UIViewController?

    public override var intrinsicContentSize: CGSize {
        hostingController?
            .viewIfLoaded?
            .intrinsicContentSize ?? super.intrinsicContentSize
    }

    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)

        tokens.customBinding { view, theme in
            if view.hostingController?.rootView.theme != theme {
                view.hostingController?.rootView.theme = theme
            }
        }
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        Task { @MainActor [hostingController] in
            hostingController?.resetParentIfNeeded()
        }
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()

        if let hostingController {
            updateHostingControllerParentIfNeeded(hostingController)
        }
    }

    public override func didMoveToWindow() {
        super.didMoveToWindow()

        if let hostingController {
            updateHostingControllerParentIfNeeded(hostingController)
        }
    }
}

extension ComponentHostingView {

    private func resolveHostingControllerParent() -> UIViewController? {
        let parent = hostingControllerExplicitParent
            ?? superview?.next(of: UIViewController.self)

        let shouldIgnoreParent = parent.map { parent in
            parent is UINavigationController
                || parent is UITabBarController
                || parent is UISplitViewController
        } ?? true

        return shouldIgnoreParent ? nil : parent
    }

    private func setupHostingController(with hostingRoot: HostingRoot) {
        let hostingController = HostingController(
            rootView: hostingRoot,
            intrinsicContentSizeInvalidation: { [weak self] in
                self?.invalidateIntrinsicContentSize()
            }
        )

        self.hostingController = hostingController

        setupHostingController(hostingController)
    }

    private func setupHostingController(_ hostingController: HostingController) {
        let hostingControllerParent = resolveHostingControllerParent()

        if let hostingControllerParent {
            hostingControllerParent.addChild(hostingController)
        }

        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.frame = bounds

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

        if let hostingControllerParent {
            hostingController.didMove(toParent: hostingControllerParent)
        }

        invalidateIntrinsicContentSize()
    }

    private func updateHostingControllerParentIfNeeded(_ hostingController: HostingController) {
        let hostingControllerParent = resolveHostingControllerParent()

        guard hostingController.parent !== hostingControllerParent else {
            return
        }

        hostingController.resetParentIfNeeded()

        if let hostingControllerParent {
            hostingControllerParent.addChild(hostingController)
            hostingController.didMove(toParent: hostingControllerParent)
        }
    }

    private func updateHostingControllerLayoutIfNeeded(_ hostingController: HostingController) {
        hostingController
            .view
            .invalidateIntrinsicContentSize()

        invalidateIntrinsicContentSize()

        if window != nil {
            hostingController.view.setNeedsLayout()
            hostingController.view.layoutIfNeeded()
        }
    }
}

extension ComponentHostingView: ComponentView {

    public func update(with content: Content, context: ComponentContext) {
        hostingControllerExplicitParent = context.componentViewController

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
            id: context.componentID,
            content: content,
            context: context,
            theme: tokens.theme
        )

        guard let hostingController else {
            return setupHostingController(with: hostingRoot)
        }

        hostingController.rootView = hostingRoot

        updateHostingControllerParentIfNeeded(hostingController)
        updateHostingControllerLayoutIfNeeded(hostingController)
    }
}
#endif
