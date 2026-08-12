#if canImport(UIKit)
import SwiftUI

internal struct FallbackComponentCacheEnvironmentKey: EnvironmentKey {

    internal static var defaultValue: FallbackComponentCache? {
        nil
    }
}

extension EnvironmentValues {

    /// Кэш для UIKit-компонентов.
    ///
    /// Используется для кэширования размеров UIKit-компонентов для использования внутри SwiftUI-представлений.
    public var fallbackComponentCache: FallbackComponentCache? {
        get { self[FallbackComponentCacheEnvironmentKey.self] }
        set { self[FallbackComponentCacheEnvironmentKey.self] = newValue }
    }
}

extension View {

    /// Устанавливает кэш для UIKit-компонентов.
    ///
    /// Используется для кэширования размеров UIKit-компонентов для использования внутри SwiftUI-представлений.
    ///
    /// - Parameter cache: Кэш для UIKit-компонентов.
    /// - Returns: Модифицированный экземпляр UI-представления.
    public nonisolated func fallbackComponentCache(_ cache: FallbackComponentCache?) -> some View {
        environment(\.fallbackComponentCache, cache)
    }
}
#endif
