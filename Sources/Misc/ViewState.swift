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
///     func sizing(fitting size: CGSize, context: ComponentContext) -> ComponentSizing {
///         ComponentSizing(width: .fill, height: .hug)
///     }
/// }
/// ```
@propertyWrapper
public struct ViewState<Value> {

    private var state: State<Value>

    /// Текущее значение, на которое ссылается переменная состояния.
    public var wrappedValue: Value {
        get { state.wrappedValue }
        nonmutating set { state.wrappedValue = newValue }
    }

    /// Байндинг для значения состояния.
    public var projectedValue: Binding<Value> {
        state.projectedValue
    }

    /// Создает состояние с начальным значением.
    ///
    /// - Parameter wrappedValue: Начальное значение.
    public init(wrappedValue: Value) {
        state = State(wrappedValue: wrappedValue)
    }

    /// Создает состояние с начальным значением.
    ///
    /// - Parameter initialValue: Начальное значение
    public init(initialValue: Value) {
        state = State(initialValue: initialValue)
    }
}

extension ViewState where Value: ExpressibleByNilLiteral {

    /// Создает состояние без начального значения.
    public init() {
        state = State()
    }
}

extension ViewState: DynamicProperty {

    public mutating func update() {
        state.update()
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

extension ViewState: Sendable where Value: Sendable { }
#endif
