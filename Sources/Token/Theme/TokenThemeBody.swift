import Foundation

public protocol TokenThemeBody: AnyObject {

    static var defaultLight: Self { get }
    static var defaultDark: Self { get }

    static var additional: [TokenThemeKey: TokenThemeUnit<Self>] { get }
}

extension TokenThemeBody {

    public static var `default`: TokenThemeUnit<Self> {
        TokenThemeUnit(
            light: .defaultLight,
            dark: .defaultDark
        )
    }

    public static var additional: [TokenThemeKey: TokenThemeUnit<Self>] {
        .empty
    }

    public static var tokens: Token<Self> {
        Token { theme in
            switch theme.scheme {
            case .light:
                Self.additional[theme.key]?.light ?? .defaultLight

            case .dark:
                Self.additional[theme.key]?.dark ?? .defaultDark
            }
        }
    }
}
