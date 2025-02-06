#if canImport(UIKit)
import SwiftUI

internal struct ComponentIdentifierEnvironmentKey: EnvironmentKey {

    internal static let defaultValue: AnyHashable? = nil
}

extension EnvironmentValues {

    /// Идентификатор для компонента.
    ///
    /// Используется в качестве идентификатора для встраивания SwiftUI-компонентов,
    /// чтобы при переиспользовании родительского контейнера (например, reusable-ячейки)
    /// компонент имел свое уникальное внешнее SwiftUI-хранилище данных.
    ///
    /// - Note: Является техническим значением окружения и не должно использоваться в обычных компонентах,
    ///         его переопределяют встроенные компоненты.
    public var componentIdentifier: AnyHashable? {
        get { self[ComponentIdentifierEnvironmentKey.self] }
        set { self[ComponentIdentifierEnvironmentKey.self] = newValue }
    }
}
#endif
