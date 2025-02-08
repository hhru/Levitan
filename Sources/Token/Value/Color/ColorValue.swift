#if canImport(UIKit)
import UIKit
#else
import CoreGraphics
#endif

import SwiftUI

public struct ColorValue:
    TokenValue,
    Changeable,
    ExpressibleByIntegerLiteral,
    Sendable {

    public var red: CGFloat
    public var green: CGFloat
    public var blue: CGFloat
    public var alpha: CGFloat

    public var hex: UInt32 {
        UInt32(min(alpha * 255.0, 255.0))
            | (UInt32(min(red * 255.0, 255.0)) << 24)
            | (UInt32(min(green * 255.0, 255.0)) << 16)
            | (UInt32(min(blue * 255.0, 255.0)) << 8)
    }

    public var hexString: String {
        String(
            format: "#%02lX%02lX%02lX%02lX",
            Int(min(red * 255.0, 255.0)),
            Int(min(green * 255.0, 255.0)),
            Int(min(blue * 255.0, 255.0)),
            Int(min(alpha * 255.0, 255.0))
        )
    }

    #if canImport(UIKit)
    public var uiColor: UIColor {
        UIColor(
            red: red,
            green: green,
            blue: blue,
            alpha: alpha
        )
    }
    #endif

    public var cgColor: CGColor {
        CGColor(
            srgbRed: red,
            green: green,
            blue: blue,
            alpha: alpha
        )
    }

    public var color: Color {
        Color(
            red: red,
            green: green,
            blue: blue,
            opacity: alpha
        )
    }

    public var isOpaque: Bool {
        alpha >= 1.0 - .leastNonzeroMagnitude
    }

    public var isClear: Bool {
        alpha <= .leastNonzeroMagnitude
    }

    public init(
        red: CGFloat,
        green: CGFloat,
        blue: CGFloat,
        alpha: CGFloat = 1.0
    ) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    public init(hex: UInt32) {
        self.init(
            red: CGFloat((hex >> 24) & 0xFF) / 255.0,
            green: CGFloat((hex >> 16) & 0xFF) / 255.0,
            blue: CGFloat((hex >> 8) & 0xFF) / 255.0,
            alpha: CGFloat(hex & 0xFF) / 255.0
        )
    }

    public init?(hexString: String) {
        var hexString = hexString

        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }

        switch hexString.count {
        case 2:
            hexString.append("\(hexString)\(hexString)")

        case 6:
            hexString.append("FF")

        case 8:
            break

        default:
            return nil
        }

        let scanner = Scanner(string: hexString)
        var scannedValue = UInt64.zero

        scanner.caseSensitive = false

        guard scanner.scanHexInt64(&scannedValue) else {
            return nil
        }

        guard scannedValue <= UInt32.max else {
            return nil
        }

        self.init(hex: UInt32(scannedValue))
    }

    #if canImport(UIKit)
    public init(uiColor: UIColor) {
        var red: CGFloat = .zero
        var green: CGFloat = .zero
        var blue: CGFloat = .zero
        var alpha: CGFloat = .zero

        uiColor.getRed(
            &red,
            green: &green,
            blue: &blue,
            alpha: &alpha
        )

        self.init(
            red: red,
            green: green,
            blue: blue,
            alpha: alpha
        )
    }

    public init(color: Color) {
        self.init(uiColor: UIColor(color))
    }
    #endif

    public init(integerLiteral hex: UInt32) {
        self.init(hex: hex)
    }
}

extension ColorValue:
    DecorableByAlpha,
    DecorableByOpacity {

    public func alpha(_ alpha: CGFloat) -> Self {
        changing { $0.alpha = alpha }
    }

    public func opacity(_ opacity: CGFloat) -> Self {
        alpha(opacity)
    }
}

extension ColorValue {

    public static var clear: Self {
        Self(
            red: .zero,
            green: .zero,
            blue: .zero,
            alpha: .zero
        )
    }
}
