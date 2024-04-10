import SwiftUI
import Combine

// TODO: Добавить документацию
@dynamicMemberLookup
@propertyWrapper
public struct ViewBinding<Value> {

    public let getter: () -> Value
    public let setter: (Value) -> Void

    public let initialValue: Value

    public var wrappedValue: Value {
        get { getter() }
        nonmutating set { setter(newValue) }
    }

    public var projectedValue: Binding<Value> {
        Binding(get: getter, set: setter)
    }

    public init(
        getter: @escaping () -> Value,
        setter: @escaping (Value) -> Void
    ) {
        self.getter = getter
        self.setter = setter

        initialValue = getter()
    }

    public subscript<Subject>(
        dynamicMember keyPath: ReferenceWritableKeyPath<Value, Subject>
    ) -> ViewBinding<Subject> {
        ViewBinding<Subject>(
            getter: { wrappedValue[keyPath: keyPath] },
            setter: { wrappedValue[keyPath: keyPath] = $0 }
        )
    }
}

extension ViewBinding: Equatable where Value: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.initialValue == rhs.initialValue
    }
}

extension ViewBinding {

    public static func constant(_ value: Value) -> Self {
        ViewBinding(
            getter: { value },
            setter: { _ in }
        )
    }

    public static func binding(_ binding: Binding<Value>) -> Self {
        ViewBinding(
            getter: { binding.wrappedValue },
            setter: { binding.wrappedValue = $0 }
        )
    }
}
