#if canImport(UIKit)
import SwiftUI

internal struct FallbackComponentCacheEnvironmentKey: EnvironmentKey {

    internal static var defaultValue: FallbackComponentCache? {
        nil
    }
}

extension EnvironmentValues {

    public var fallbackComponentCache: FallbackComponentCache? {
        get { self[FallbackComponentCacheEnvironmentKey.self] }
        set { self[FallbackComponentCacheEnvironmentKey.self] = newValue }
    }
}
#endif
