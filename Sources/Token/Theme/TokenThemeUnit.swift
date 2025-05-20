import Foundation

public struct TokenThemeUnit<Body: TokenThemeBody> {

    public let light: Body
    public let dark: Body

    public init(light: Body, dark: Body) {
        self.light = light
        self.dark = dark
    }

    public init(single: Body) {
        self.init(light: single, dark: single)
    }
}

extension TokenThemeUnit: Sendable where Body: Sendable { }
