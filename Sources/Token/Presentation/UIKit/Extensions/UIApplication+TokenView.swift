import UIKit

extension UIApplication: TokenView {

    internal var tokenViewRoot: TokenView? {
        nil
    }

    internal var tokenViewParent: TokenView? {
        nil
    }

    internal var tokenViewChildren: [TokenView] {
        connectedScenes.compactMap { $0 as? UIWindowScene }
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
