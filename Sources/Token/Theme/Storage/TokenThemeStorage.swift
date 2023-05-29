import Foundation

public protocol TokenThemeStorage {

    func storeSelectedThemeKey(_ themeKey: TokenThemeKey?)
    func restoreSelectedThemeKey() -> TokenThemeKey?

    func storeSelectedThemeScheme(_ themeScheme: TokenThemeScheme?)
    func restoreSelectedThemeScheme() -> TokenThemeScheme?
}
