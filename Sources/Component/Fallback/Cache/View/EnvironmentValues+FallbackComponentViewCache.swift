#if canImport(UIKit)
import SwiftUI

internal struct FallbackComponentViewCacheEnvironmentKey: EnvironmentKey {

    internal static let defaultValue = FallbackComponentViewCache()
}

extension EnvironmentValues {

    internal var fallbackComponentViewCache: FallbackComponentViewCache {
        get { self[FallbackComponentViewCacheEnvironmentKey.self] }
        set { self[FallbackComponentViewCacheEnvironmentKey.self] = newValue }
    }
}
#endif
