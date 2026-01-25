#if canImport(UIKit)
import SwiftUI

internal struct ComponentCacheEnvironmentKey: EnvironmentKey {

    internal static var defaultValue: ComponentCache? {
        nil
    }
}

extension EnvironmentValues {

    /// Кэш для компонентов.
    ///
    /// Используется для хранения размеров компонентов с более "умным" механизмом их переиспользования.
    /// По умолчанию кэширование отсутствует.
    public var componentCache: ComponentCache? {
        get { self[ComponentCacheEnvironmentKey.self] }
        set { self[ComponentCacheEnvironmentKey.self] = newValue }
    }
}

extension View {

    /// Устанавливает кэш для компонентов.
    ///
    /// Используется для хранения размеров компонентов с более "умным" механизмом их переиспользования.
    /// По умолчанию кэширование отсутствует.
    public nonisolated func componentCache(_ cache: ComponentCache?) -> some View {
        environment(\.componentCache, cache)
    }
}
#endif
