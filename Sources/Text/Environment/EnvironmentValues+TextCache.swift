#if canImport(UIKit)
import SwiftUI

internal struct TextCacheEnvironmentKey: EnvironmentKey {

    internal static var defaultValue: TextCache? {
        nil
    }
}

extension EnvironmentValues {

    public var textCache: TextCache? {
        get { self[TextCacheEnvironmentKey.self] }
        set { self[TextCacheEnvironmentKey.self] = newValue }
    }
}
#endif
