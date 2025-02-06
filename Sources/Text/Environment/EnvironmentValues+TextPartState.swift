#if canImport(UIKit)
import SwiftUI

internal struct TextPartStateKey: EnvironmentKey {

    internal static let defaultValue = TextPartState.default
}

extension EnvironmentValues {

    public var textPartState: TextPartState {
        get { self[TextPartStateKey.self] }
        set { self[TextPartStateKey.self] = newValue }
    }
}
#endif
