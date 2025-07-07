#if canImport(UIKit)
import Combine
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

@MainActor
private var tokenViewWindowScenesObservation: AnyCancellable?

extension UIWindowScene {

    internal static func handleTokenViewEvents() {
        tokenViewWindowScenesObservation = NotificationCenter
            .default
            .publisher(for: UIWindowScene.didActivateNotification)
            .compactMap { $0.object as? TokenView }
            .sink { $0.tokenViewManager.updateTheme() }
    }
}
#endif
