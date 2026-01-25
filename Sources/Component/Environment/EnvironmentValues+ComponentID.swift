#if canImport(UIKit)
import SwiftUI

internal struct ComponentIDEnvironmentKey: EnvironmentKey {

    internal static var defaultValue: ComponentID? { nil }
}

extension EnvironmentValues {

    /// Идентификатор для компонента.
    ///
    /// Используется в качестве идентификатора для встраивания SwiftUI-компонентов,
    /// чтобы при переиспользовании родительского контейнера (например, reusable-ячейки)
    /// компонент имел свое уникальное внешнее SwiftUI-хранилище данных.
    public var componentID: ComponentID? {
        get { self[ComponentIDEnvironmentKey.self] }
        set { self[ComponentIDEnvironmentKey.self] = newValue }
    }
}

extension View {

    /// Устанавливает идентификатор компонента в окружении.
    ///
    /// Используется в качестве идентификатора для встраивания SwiftUI-компонентов,
    /// чтобы при переиспользовании родительского контейнера (например, reusable-ячейки)
    /// компонент имел свое уникальное внешнее SwiftUI-хранилище данных.
    public nonisolated func componentID(_ id: ComponentID?) -> some View {
        environment(\.componentID, id)
    }
}
#endif
