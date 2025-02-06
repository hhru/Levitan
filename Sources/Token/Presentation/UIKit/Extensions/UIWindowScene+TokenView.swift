#if canImport(UIKit1)
import UIKit

extension UIWindowScene: TokenView {

    internal var tokenViewRoot: TokenView? {
        UIApplication.shared
    }

    internal var tokenViewParent: TokenView? {
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
        windows
    }

    internal var shouldAlwaysOverrideUserInterfaceStyle: Bool {
        true
    }

    internal func overrideUserInterfaceStyle(themeScheme: TokenThemeScheme) {
        for child in tokenViewChildren {
            child.overrideUserInterfaceStyle(themeScheme: themeScheme)
        }
    }
}

private var tokenViewWindowScenesObservation: NSObjectProtocol?

extension UIWindowScene {

    internal static func handleTokenViewEvents() {
        tokenViewWindowScenesObservation = NotificationCenter.default.addObserver(
            forName: UIWindowScene.didActivateNotification,
            object: nil,
            queue: nil
        ) { notification in
            if let tokenView = notification.object as? TokenView {
                tokenView.tokenViewManager.updateTheme()
            }
        }
    }
}
#endif
