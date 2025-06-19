#if canImport(UIKit)
import SwiftUI

internal struct FallbackComponentSizeCacheEnvironmentKey: EnvironmentKey {

    internal static var defaultValue: FallbackComponentSizeCache? {
        nil
    }
}

extension EnvironmentValues {

    public var fallbackComponentSizeCache: FallbackComponentSizeCache? {
        get { self[FallbackComponentSizeCacheEnvironmentKey.self] }
        set { self[FallbackComponentSizeCacheEnvironmentKey.self] = newValue }
    }
}
#endif
