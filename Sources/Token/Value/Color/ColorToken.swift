import UIKit
import SwiftUI

public typealias ColorToken = Token<ColorValue>

extension ColorToken {

    public init(
        red: CGFloat,
        green: CGFloat,
        blue: CGFloat,
        alpha: CGFloat = 1.0
    ) {
        self = Value(
            red: red,
            green: green,
            blue: blue,
            alpha: alpha
        ).token
    }

    public init(
        red: CGFloat,
        green: CGFloat,
        blue: CGFloat,
        opacity: OpacityToken
    ) {
        self = Token(traits: [red, green, blue, opacity]) { theme in
            Value(
                red: red,
                green: green,
                blue: blue,
                alpha: opacity.resolve(for: theme)
            )
        }
    }

    public init(hex: UInt32) {
        self = ColorValue(hex: hex).token
    }

    public init?(hexString: String) {
        guard let value = Value(hexString: hexString) else {
            return nil
        }

        self = value.token
    }

    public init(uiColor: UIColor) {
        self = ColorValue(uiColor: uiColor).token
    }

    public init(color: Color) {
        self.init(uiColor: UIColor(color))
    }
}

extension ColorToken {

    public static var clear: Self {
        Self(
            red: .zero,
            green: .zero,
            blue: .zero,
            alpha: .zero
        )
    }
}
