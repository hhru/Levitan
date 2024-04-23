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

    public func equating<Wrapped: Hashable>(to value: Wrapped) -> ViewBinding<Bool>
    where Value == Wrapped? {
        ViewBinding<Bool> {
            getter() == value
        } setter: { newValue in
            if newValue {
                setter(value)
            } else if getter() == value {
                setter(nil)
            }
        }
    }

    public subscript<Subject>(
        dynamicMember keyPath: ReferenceWritableKeyPath<Value, Subject>
    ) -> ViewBinding<Subject> {
        ViewBinding<Subject>(
            getter: { wrappedValue[keyPath: keyPath] },
            setter: { wrappedValue[keyPath: keyPath] = $0 }
        )
    }

    public subscript<Subject: Hashable>(
        dynamicMember keyPath: ReferenceWritableKeyPath<Value, Subject?>
    ) -> ViewFocusBinding<Subject?> {
        ViewFocusBinding(binding: self[dynamicMember: keyPath])
    }

    public subscript(
        dynamicMember keyPath: ReferenceWritableKeyPath<Value, Bool>
    ) -> ViewFocusBinding<Bool> {
        ViewFocusBinding(binding: self[dynamicMember: keyPath])
    }
}

extension ViewBinding where
    Value: Changeable,
    Value.ChangeableCopy == ChangeableWrapper<Value> {

    public subscript<Subject>(
        dynamicMember keyPath: KeyPath<Value, Subject>
    ) -> ViewBinding<Subject> {
        ViewBinding<Subject>(
            getter: { getter()[keyPath: keyPath] },
            setter: { setter(getter().changing(keyPath, to: $0)) }
        )
    }

    public subscript<Subject: ExpressibleByStringLiteral>(
        dynamicMember keyPath: KeyPath<Value, Subject>
    ) -> ViewBinding<Subject?> {
        ViewBinding<Subject?>(
            getter: { getter()[keyPath: keyPath] },
            setter: { setter(getter().changing(keyPath, to: $0 ?? "")) }
        )
    }

    public subscript<Subject: ExpressibleByArrayLiteral>(
        dynamicMember keyPath: KeyPath<Value, Subject>
    ) -> ViewBinding<Subject?> {
        ViewBinding<Subject?>(
            getter: { getter()[keyPath: keyPath] },
            setter: { setter(getter().changing(keyPath, to: $0 ?? [])) }
        )
    }

    public subscript<Subject: ExpressibleByDictionaryLiteral>(
        dynamicMember keyPath: KeyPath<Value, Subject>
    ) -> ViewBinding<Subject?> {
        ViewBinding<Subject?>(
            getter: { getter()[keyPath: keyPath] },
            setter: { setter(getter().changing(keyPath, to: $0 ?? [:])) }
        )
    }

    public subscript<Subject: Hashable>(
        dynamicMember keyPath: KeyPath<Value, Subject?>
    ) -> ViewFocusBinding<Subject?> {
        ViewFocusBinding(binding: self[dynamicMember: keyPath])
    }

    public subscript(
        dynamicMember keyPath: KeyPath<Value, Bool>
    ) -> ViewFocusBinding<Bool> {
        ViewFocusBinding(binding: self[dynamicMember: keyPath])
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
