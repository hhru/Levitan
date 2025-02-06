#if canImport(UIKit1)
import UIKit
#endif

import SwiftUI

public enum TokenThemeScheme: String, Sendable {

    case light
    case dark

    #if canImport(UIKit1)
    public var uiUserInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .light:
            return .light

        case .dark:
            return .dark
        }
    }
    #endif

    public var colorScheme: ColorScheme {
        switch self {
        case .light:
            return .light

        case .dark:
            return .dark
        }
    }

    #if canImport(UIKit1)
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
    #endif

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
