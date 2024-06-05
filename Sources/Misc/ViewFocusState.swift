import SwiftUI

// TODO: Добавить документацию
@available(iOS 15.0, tvOS 15.0, *)
@propertyWrapper
public struct ViewFocusState<Value: Hashable>: DynamicProperty {

    private var focusState: FocusState<Value>

    public var wrappedValue: Value {
        get { focusState.wrappedValue }
        nonmutating set { focusState.wrappedValue = newValue }
    }

    public var projectedValue: FocusState<Value>.Binding {
        focusState.projectedValue
    }

    public init() where Value == Bool {
        self.focusState = FocusState()
    }

    public init<Wrapped: Hashable>() where Value == Wrapped? {
        self.focusState = FocusState()
    }

    public mutating func update() {
        focusState.update()
    }
}

@available(iOS 15.0, tvOS 15.0, *)
extension ViewFocusState: Equatable where Value: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        true
    }
}
