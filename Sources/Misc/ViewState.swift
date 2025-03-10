#if canImport(UIKit)
import SwiftUI

/// Обертка для реализации внутреннего состояния UI-компонента.
///
/// Является Equatable-аналогом `State` из SwiftUI
/// и используется для реализации протокола `Equatable` в компонентах,
/// в которых экземпляры `ViewState` всегда будут равны.
///
/// На самом деле сравнение экземпляров `State` не имеет смысла,
/// так как они содержат актуальные данные только внутри вызова `body`.
/// Но так как в рамках компонентов внутренний стейт относится к слою UI-представления,
/// то для сравнения слоя данных их необходимо исключать.
/// И чтобы не реализовывать требования протокола `Equatable` вручную,
/// удобно использовать данную обертку, например:
///
/// ``` swift
/// struct Foo: Component {
///
///     @ViewState
///     private var text: String
///
///     var body: some View {
///         TextField("Text", text: $text)
///     }
///
///     func sizing(
///         fitting size: CGSize,
///         context: ComponentContext
///     ) -> ComponentSizing {
///         ComponentSizing(
///             width: .fill,
///             height: .hug
///         )
///     }
/// }
/// ```
@propertyWrapper
public struct ViewState<Value>: DynamicProperty {

    private var environment = Environment(\.componentIdentifier)
    private var state = State<[AnyHashable?: Value]>(wrappedValue: [:])

    private var initialValue: Value

    private var identifier: AnyHashable? {
        environment.wrappedValue
    }

    /// Текущее значение, на которое ссылается переменная состояния.
    public var wrappedValue: Value {
        get { state.wrappedValue[identifier] ?? initialValue }
        nonmutating set { state.wrappedValue[identifier] = newValue }
    }

    // TODO: Добавить поддержку в компоненты SwiftUI и возвращать ViewBinding
    /// Байндинг для значения состояния.
    public var projectedValue: Binding<Value> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }

    /// Создает состояние с начальным значением.
    ///
    /// - Parameter value: Начальное значение.
    public init(wrappedValue value: Value) {
        initialValue = value
    }

    /// Создает состояние с начальным значением.
    ///
    /// - Parameter value: Начальное значение
    public init(initialValue value: Value) {
        self.init(wrappedValue: value)
    }

    public mutating func update() {
        environment.update()
        state.update()
    }
}

extension ViewState where Value: ExpressibleByNilLiteral {

    /// Создает состояние без начального значения.
    public init() {
        self.init(wrappedValue: nil)
    }
}

extension ViewState: Equatable where Value: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        true
    }
}

extension ViewState: Hashable where Value: Hashable {

    public func hash(into hasher: inout Hasher) { }
}
#endif
