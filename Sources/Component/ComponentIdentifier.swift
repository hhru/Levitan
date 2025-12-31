#if canImport(UIKit)
import Foundation

/// Идентификатор компонента.
///
/// Используется в качестве Sendable-идентификатора для встраивания SwiftUI-компонентов,
/// чтобы при переиспользовании родительского контейнера (например, reusable-ячейки)
/// компонент имел свое уникальное внешнее SwiftUI-хранилище данных.
public struct ComponentIdentifier: Hashable, @unchecked Sendable {

    /// Значение идентификатора.
    public let value: AnyHashable

    /// Уточнения идентификатора.
    public let traits: AnyHashable?

    private init(
        _ value: AnyHashable,
        traits: AnyHashable? = nil
    ) {
        self.value = value
        self.traits = traits
    }

    /// Создает идентификатор компонента с его уточнениями.
    ///
    /// - Parameters:
    ///   - value: Значение идентификатора.
    ///   - traits: Уточнения идентификатора.
    public init(
        _ value: some Hashable & Sendable,
        traits: some Hashable & Sendable
    ) {
        self.init(
            value as AnyHashable,
            traits: traits as AnyHashable
        )
    }

    /// Создает идентификатор компонента без уточнений.
    ///
    /// - Parameter value: Значение идентификатора.
    public init(_ value: some Hashable & Sendable) {
        self.init(value as AnyHashable)
    }

    /// Модифицирует идентификатор компонента, заменяя его уточнения.
    ///
    /// - Parameter traits: Новые уточнения идентификатора.
    /// - Returns: Новый идентификатор компонента.
    public func traits(_ traits: some Hashable & Sendable) -> Self {
        Self(value, traits: traits)
    }
}
#endif
