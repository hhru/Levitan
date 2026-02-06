import SwiftUI

// TODO: Добавить документацию
@propertyWrapper
public struct ViewFocusState<Value: Hashable> {

    private var focusState: FocusState<Value>

    public var wrappedValue: Value {
        get { focusState.wrappedValue }
        nonmutating set { focusState.wrappedValue = newValue }
    }

    // TODO: Перенести наработки из проекта и возвращать ViewFocusState
    public var projectedValue: FocusState<Value>.Binding {
        focusState.projectedValue
    }

    public init() where Value == Bool {
        self.focusState = FocusState()
    }

    public init<Wrapped: Hashable>() where Value == Wrapped? {
        self.focusState = FocusState()
    }
}

extension ViewFocusState: DynamicProperty {

    public mutating func update() {
        focusState.update()
    }
}

extension ViewFocusState: Equatable where Value: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        true
    }
}

extension ViewFocusState: Hashable where Value: Hashable {

    public func hash(into hasher: inout Hasher) { }
}
