import UIKit

extension UIView: TokenView {

    internal var tokenViewParent: TokenView? {
        if let next, next is UIView {
            return superview
        }

        var responder = self as UIResponder

        while let nextResponder = responder.next {
            if let tokenView = nextResponder as? TokenView {
                return tokenView
            }

            responder = nextResponder
        }

        return nil
    }

    internal var tokenViewChildren: [TokenView] {
        subviews.reduce(into: [layer]) { children, view in
            guard let parent = view.tokenViewParent else {
                return
            }

            if self === parent {
                children.append(view)
            } else {
                children.append(parent)
            }
        }
    }

    internal var shouldAlwaysOverrideUserInterfaceStyle: Bool {
        self is UIWindow
    }

    internal func overrideUserInterfaceStyle(themeScheme: TokenThemeScheme?) {
        overrideUserInterfaceStyle = themeScheme?.uiUserInterfaceStyle ?? .unspecified
    }
}

private var tokenViewWindowsObservation: NSObjectProtocol?

extension UIView {

    internal static func observeTokenViewEvents() {
        tokenViewWindowsObservation = NotificationCenter.default.addObserver(
            forName: UIWindow.didBecomeVisibleNotification,
            object: nil,
            queue: nil
        ) { notification in
            if let tokenView = notification.object as? TokenView {
                tokenView.tokenViewManager.updateTheme()
            }
        }

        MethodSwizzler.swizzle(
            class: UIWindow.self,
            originalSelector: #selector(setter: UIWindow.windowScene),
            swizzledSelector: #selector(UIWindow.setTokenViewWindowScene(_:))
        )

        MethodSwizzler.swizzle(
            class: UIView.self,
            originalSelector: #selector(UIView.didMoveToSuperview),
            swizzledSelector: #selector(UIView.tokenViewDidMoveToSuperview)
        )
    }

    @objc
    private dynamic func setTokenViewWindowScene(_ windowScene: UIWindowScene?) {
        setTokenViewWindowScene(windowScene)

        guard !isHidden, windowScene != nil else {
            return
        }

        tokenViewManager.updateTheme()
    }

    @objc
    private dynamic func tokenViewDidMoveToSuperview() {
        tokenViewDidMoveToSuperview()

        guard let superview, let tokenViewParent else {
            return
        }

        if superview === tokenViewParent {
            tokenViewManager.updateTheme()
        } else {
            tokenViewParent.tokenViewManager.updateTheme()
        }
    }
}
