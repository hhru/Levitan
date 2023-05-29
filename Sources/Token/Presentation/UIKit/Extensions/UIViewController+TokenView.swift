import UIKit

extension UIViewController: TokenView {

    internal var tokenViewParent: TokenView? {
        view.superview
    }

    internal var tokenViewChildren: [TokenView] {
        [view]
    }

    internal func overrideUserInterfaceStyle(themeScheme: TokenThemeScheme?) {
        overrideUserInterfaceStyle = themeScheme?.uiUserInterfaceStyle ?? .unspecified
    }
}
