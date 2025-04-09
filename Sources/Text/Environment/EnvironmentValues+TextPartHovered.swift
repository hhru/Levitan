#if canImport(UIKit)
import SwiftUI

internal struct TextPartHoveredKey: EnvironmentKey {

    internal static let defaultValue = false
}

extension EnvironmentValues {

    public var isTextPartHovered: Bool {
        get { self[TextPartHoveredKey.self] }
        set { self[TextPartHoveredKey.self] = newValue }
    }
}
#endif
