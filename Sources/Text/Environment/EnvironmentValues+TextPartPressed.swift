#if canImport(UIKit)
import SwiftUI

internal struct TextPartPressedKey: EnvironmentKey {

    internal static let defaultValue = false
}

extension EnvironmentValues {

    public var isTextPartPressed: Bool {
        get { self[TextPartPressedKey.self] }
        set { self[TextPartPressedKey.self] = newValue }
    }
}
#endif
