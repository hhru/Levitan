#if canImport(UIKit)
import Foundation

/// Идентификатор компонента.
///
/// Используется в качестве Sendable-идентификатора для встраивания SwiftUI-компонентов,
/// чтобы при переиспользовании родительского контейнера (например, reusable-ячейки)
/// компонент имел свое уникальное внешнее SwiftUI-хранилище данных.
///
/// - SeeAlso: ``Component``
public struct ComponentID: Hashable, @unchecked Sendable {

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

    /// Модифицирует идентификатор компонента, добавляя к нему уточнение.
    ///
    /// - Parameter traits: Уточнения идентификатора.
    /// - Returns: Новый идентификатор компонента.
    public func traits(_ traits: some Hashable & Sendable) -> Self {
        Self(self, traits: traits)
    }
}

extension ComponentID {

    /// Определяет равенство идентификатора компонента и Hashable-значения любого типа.
    ///
    /// Возвращает `true`, если сами экземпляры равны,
    /// либо если значение идентификатора равно другому значению,
    /// но при этом у него отсутствуют уточнения.
    ///
    /// - Parameters:
    ///   - lhs: Идентификатор компонента.
    ///   - rhs: Hashable-значение идентификатора.
    /// - Returns: Результат сравнения.
    public static func == (lhs: Self, rhs: AnyHashable) -> Bool {
        if lhs as AnyHashable == rhs {
            return true
        }

        if lhs == rhs as? ComponentID {
            return true
        }

        return lhs.value == rhs && lhs.traits == nil
    }

    /// Определяет равенство Hashable-значения любого типа и идентификатора компонента.
    ///
    /// Возвращает `true`, если сами экземпляры равны,
    /// либо если значение идентификатора равно другому значению,
    /// но при этом у него отсутствуют уточнения.
    ///
    /// - Parameters:
    ///   - lhs: Hashable-значение идентификатора.
    ///   - rhs: Идентификатор компонента.
    /// - Returns: Результат сравнения.
    public static func == (lhs: AnyHashable, rhs: Self) -> Bool {
        if lhs == rhs as AnyHashable {
            return true
        }

        if lhs as? ComponentID == rhs {
            return true
        }

        return lhs == rhs.value && rhs.traits == nil
    }
}

extension ComponentID: CustomStringConvertible {

    public var description: String {
        if let traits {
            return "\(value) (\(traits))"
        }

        return "\(value)"
    }
}

/// Определяет равенство опционального идентификатора компонента и Hashable-значения любого типа.
///
/// Возвращает `true`, если сами экземпляры равны,
/// либо если значение идентификатора равно другому значению,
/// но при этом у него отсутствуют уточнения.
///
/// - Parameters:
///   - lhs: Идентификатор компонента.
///   - rhs: Hashable-значение идентификатора.
/// - Returns: Результат сравнения.
public func == (lhs: ComponentID?, rhs: AnyHashable) -> Bool {
    if lhs as AnyHashable == rhs {
        return true
    }

    if let lhs, (lhs as AnyHashable == rhs) || (lhs.value == rhs && lhs.traits == nil) {
        return true
    }

    return false
}

/// Определяет равенство Hashable-значения любого типа и опционального идентификатора компонента.
///
/// Возвращает `true`, если сами экземпляры равны,
/// либо если значение идентификатора равно другому значению,
/// но при этом у него отсутствуют уточнения.
///
/// - Parameters:
///   - lhs: Hashable-значение идентификатора.
///   - rhs: Идентификатор компонента.
/// - Returns: Результат сравнения.
public func == (lhs: AnyHashable, rhs: ComponentID?) -> Bool {
    if lhs == rhs as AnyHashable {
        return true
    }

    if let rhs, (lhs == rhs as AnyHashable) || (lhs == rhs.value && rhs.traits == nil) {
        return true
    }

    return false
}
#endif
