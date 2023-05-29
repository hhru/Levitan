import Foundation

public final class DefaultTokenThemeStorage: TokenThemeStorage {

    private enum Keys {
        static let selectedThemeKey = "tokenThemeKey"
        static let selectedThemeScheme = "tokenThemeScheme"
    }

    private let userDefaults: UserDefaults

    public init(suiteName: String? = nil) {
        userDefaults = suiteName.flatMap { suiteName in
            UserDefaults(suiteName: suiteName)
        } ?? .standard
    }

    public func storeSelectedThemeKey(_ themeKey: TokenThemeKey?) {
        userDefaults.set(
            themeKey?.rawValue,
            forKey: Keys.selectedThemeKey
        )
    }

    public func restoreSelectedThemeKey() -> TokenThemeKey? {
        userDefaults
            .string(forKey: Keys.selectedThemeKey)
            .flatMap(TokenThemeKey.init(rawValue:))
    }

    public func storeSelectedThemeScheme(_ themeScheme: TokenThemeScheme?) {
        userDefaults.set(
            themeScheme?.rawValue,
            forKey: Keys.selectedThemeScheme
        )
    }

    public func restoreSelectedThemeScheme() -> TokenThemeScheme? {
        userDefaults
            .string(forKey: Keys.selectedThemeScheme)
            .flatMap(TokenThemeScheme.init(rawValue:))
    }
}
