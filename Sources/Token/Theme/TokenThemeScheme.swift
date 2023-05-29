import UIKit
import SwiftUI

public enum TokenThemeScheme: String, Sendable {

    case light
    case dark

    public var uiUserInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .light:
            return .light

        case .dark:
            return .dark
        }
    }

    public var colorScheme: ColorScheme {
        switch self {
        case .light:
            return .light

        case .dark:
            return .dark
        }
    }

    public init?(uiUserInterfaceStyle: UIUserInterfaceStyle) {
        switch uiUserInterfaceStyle {
        case .light:
            self = .light

        case .dark:
            self = .dark

        case .unspecified:
            return nil

        @unknown default:
            return nil
        }
    }

    public init(colorScheme: ColorScheme) {
        switch colorScheme {
        case .light:
            self = .light

        case .dark:
            self = .dark

        @unknown default:
            self = .light
        }
    }
}
