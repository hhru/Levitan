import Foundation
import Combine

internal class TokenViewPayload {

    internal var propertyBindings: [AnyHashable: TokenViewBinding] = .empty
    internal var customBindings: [TokenViewBinding] = .empty

    internal var themeManager: TokenThemeManager?
    internal var themeSubscription: AnyCancellable?

    internal var themeKey: TokenThemeKey?
    internal var themeScheme: TokenThemeScheme?

    internal var theme: TokenTheme?
}
