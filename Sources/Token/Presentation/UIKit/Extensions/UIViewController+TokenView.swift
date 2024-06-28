import UIKit

extension UIViewController: TokenView {

    internal var tokenViewRoot: TokenView? {
        UIApplication.shared
    }

    internal var tokenViewParent: TokenView? {
        viewIfLoaded?.superview
    }

    internal var tokenViewChildren: [TokenView] {
        [viewIfLoaded].compactMap { $0 }
    }

    internal func overrideUserInterfaceStyle(themeScheme: TokenThemeScheme) {
        overrideUserInterfaceStyle = themeScheme.uiUserInterfaceStyle
    }
}
