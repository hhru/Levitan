import SwiftUI
import Combine

// TODO: Добавить документацию
@dynamicMemberLookup
@propertyWrapper
public struct ViewBinding<Value> {

    private final class Storage {

        let get: () -> Value
        let set: (Value) -> Void

        lazy var initialValue = get()

        init(
            get: @escaping () -> Value,
            set: @escaping (Value) -> Void
        ) {
            self.get = get
            self.set = set
        }
    }

    private let storage: Storage

    public var get: () -> Value {
        storage.get
    }

    public var set: (Value) -> Void {
        storage.set
    }

    public var initialValue: Value {
        storage.initialValue
    }

    public var wrappedValue: Value {
        get { get() }
        nonmutating set { set(newValue) }
    }

    public var projectedValue: Binding<Value> {
        Binding(get: get, set: set)
    }

    public init(
        get: @escaping () -> Value,
        set: @escaping (Value) -> Void
    ) {
        storage = Storage(
            get: get,
            set: set
        )
    }

    public init(projectedValue: Binding<Value>) {
        self.init(
            get: { projectedValue.wrappedValue },
            set: { projectedValue.wrappedValue = $0 }
        )
    }

    public func equating<Wrapped: Hashable>(to value: Wrapped) -> ViewBinding<Bool>
    where Value == Wrapped? {
        ViewBinding<Bool> {
            get() == value
        } set: { newValue in
            if newValue {
                set(value)
            } else if get() == value {
                set(nil)
            }
        }
    }

    public subscript<Subject>(
        dynamicMember keyPath: ReferenceWritableKeyPath<Value, Subject>
    ) -> ViewBinding<Subject> {
        ViewBinding<Subject>(
            get: { wrappedValue[keyPath: keyPath] },
            set: { wrappedValue[keyPath: keyPath] = $0 }
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
            get: { get()[keyPath: keyPath] },
            set: { set(get().changing(keyPath, to: $0)) }
        )
    }

    public subscript<Subject: ExpressibleByStringLiteral>(
        dynamicMember keyPath: KeyPath<Value, Subject>
    ) -> ViewBinding<Subject?> {
        ViewBinding<Subject?>(
            get: { get()[keyPath: keyPath] },
            set: { set(get().changing(keyPath, to: $0 ?? "")) }
        )
    }

    public subscript<Subject: ExpressibleByArrayLiteral>(
        dynamicMember keyPath: KeyPath<Value, Subject>
    ) -> ViewBinding<Subject?> {
        ViewBinding<Subject?>(
            get: { get()[keyPath: keyPath] },
            set: { set(get().changing(keyPath, to: $0 ?? [])) }
        )
    }

    public subscript<Subject: ExpressibleByDictionaryLiteral>(
        dynamicMember keyPath: KeyPath<Value, Subject>
    ) -> ViewBinding<Subject?> {
        ViewBinding<Subject?>(
            get: { get()[keyPath: keyPath] },
            set: { set(get().changing(keyPath, to: $0 ?? [:])) }
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

extension ViewBinding: Hashable where Value: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(initialValue)
    }
}

extension ViewBinding {

    public static func constant(_ value: Value) -> Self {
        ViewBinding(
            get: { value },
            set: { _ in }
        )
    }

    public static func binding(_ binding: Binding<Value>) -> Self {
        ViewBinding(
            get: { binding.wrappedValue },
            set: { binding.wrappedValue = $0 }
        )
    }
}
