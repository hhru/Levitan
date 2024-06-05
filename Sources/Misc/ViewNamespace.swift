import SwiftUI

@propertyWrapper
/// Обертка для создания пространства имен с постоянным идентификатором UI-компонента,
/// который его содержит.
///
/// Является Equatable-аналогом `Namespace` из SwiftUI
/// и используется для реализации протокола `Equatable` в компонентах,
/// в которых экземпляры `ViewNamespace` всегда будут равны.
///
/// На самом деле сравнение экземпляров `Namespace` не имеет смысла,
/// так как они содержат актуальные данные только внутри вызова `body`.
/// Но так как в рамках компонентов внутренний стейт относится к слою UI-представления,
/// то для сравнения слоя данных их необходимо исключать.
/// И чтобы не реализовывать требования протокола `Equatable` вручную,
/// удобно использовать данную обертку.
///
/// - SeeAlso: ``Namespace``
public struct ViewNamespace: DynamicProperty, Sendable {

    /// Тип идентификатора пространства имен.
    public typealias ID = Namespace.ID

    private var namespace: Namespace

    public var wrappedValue: ID {
        namespace.wrappedValue
    }

    /// Создает пространство имен.
    public init() {
        namespace = Namespace()
    }

    public mutating func update() {
        namespace.update()
    }
}

extension ViewNamespace: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        true
    }
}
