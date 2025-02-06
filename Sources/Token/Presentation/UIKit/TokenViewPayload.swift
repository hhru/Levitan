#if canImport(UIKit1)
import Foundation
import Combine

internal class TokenViewPayload {

    internal var propertyBindings: [AnyHashable: TokenViewBinding] = [:]
    internal var customBindings: [TokenViewBinding] = []

    internal var themeManager: TokenThemeManager?
    internal var themeSubscription: AnyCancellable?

    internal var themeKey: TokenThemeKey?
    internal var themeScheme: TokenThemeScheme?

    internal var theme: TokenTheme?
}
#endif
