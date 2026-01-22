#if canImport(UIKit)
import SwiftUI

internal struct ComponentCacheEnvironmentKey: EnvironmentKey {

    internal static var defaultValue: ComponentCache? {
        nil
    }
}

extension EnvironmentValues {

    public var componentCache: ComponentCache? {
        get { self[ComponentCacheEnvironmentKey.self] }
        set { self[ComponentCacheEnvironmentKey.self] = newValue }
    }
}
#endif
