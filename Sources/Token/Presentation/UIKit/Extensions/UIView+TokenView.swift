#if canImport(UIKit)
import Combine
import UIKit

extension UIView: TokenView {

    internal var tokenViewRoot: TokenView? {
        UIApplication.shared
    }

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

    internal func overrideUserInterfaceStyle(themeScheme: TokenThemeScheme) {
        overrideUserInterfaceStyle = themeScheme.uiUserInterfaceStyle
    }
}

@MainActor
private var tokenViewWindowsObservation: AnyCancellable?

extension UIView {

    // До внедрения свизлинга для поддержки токенов использовался глобальный менеджер всех UI-представлений,
    // который показал очень низкую производительность.
    // После отказа от iOS 16, стоит рассмотреть возможность замены свизлинга
    // на кастомизацию UITraitCollection: https://developer.apple.com/documentation/uikit/uitraitcollection#4250876
    internal static func handleTokenViewEvents() {

        tokenViewWindowsObservation = NotificationCenter.default.publisher(
            for: UIWindow.didBecomeVisibleNotification
        )
        .compactMap { $0.object as? TokenView }
        .sink { tokenView in
            if Thread.isMainThread {
                tokenView.tokenViewManager.updateTheme()
            } else {
                Task { @MainActor in
                    tokenView.tokenViewManager.updateTheme()
                }
            }
        }

        MethodSwizzler.swizzle(
            class: UIWindow.self,
            originalSelector: #selector(setter: UIWindow.windowScene),
            swizzledSelector: #selector(UIWindow._setWindowScene(_:))
        )

        MethodSwizzler.swizzle(
            class: UIView.self,
            originalSelector: #selector(UIView.didMoveToSuperview),
            swizzledSelector: #selector(UIView._didMoveToSuperview)
        )
    }

    @objc
    private dynamic func _setWindowScene(_ windowScene: UIWindowScene?) {
        _setWindowScene(windowScene)

        guard !isHidden, windowScene != nil else {
            return
        }

        tokenViewManager.updateTheme()
    }

    @objc
    private dynamic func _didMoveToSuperview() {
        _didMoveToSuperview()

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
#endif
