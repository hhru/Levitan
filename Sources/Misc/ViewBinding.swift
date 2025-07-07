#if canImport(UIKit)
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

    @MainActor
    public var projectedValue: Binding<Value> {
        Binding(get: { get() }, set: { set($0) })
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
        dynamicMember keyPath: WritableKeyPath<Value, Subject>
    ) -> ViewBinding<Subject> {
        ViewBinding<Subject>(
            get: { wrappedValue[keyPath: keyPath] },
            set: { wrappedValue[keyPath: keyPath] = $0 }
        )
    }

    public subscript<Subject: ExpressibleByStringLiteral>(
        dynamicMember keyPath: WritableKeyPath<Value, Subject>
    ) -> ViewBinding<Subject?> {
        ViewBinding<Subject?>(
            get: { get()[keyPath: keyPath] },
            set: { newValue in
                var value = get()

                value[keyPath: keyPath] = newValue ?? ""

                set(value)
            }
        )
    }

    public subscript<Subject: ExpressibleByArrayLiteral>(
        dynamicMember keyPath: WritableKeyPath<Value, Subject>
    ) -> ViewBinding<Subject?> {
        ViewBinding<Subject?>(
            get: { get()[keyPath: keyPath] },
            set: { newValue in
                var value = get()

                value[keyPath: keyPath] = newValue ?? []

                set(value)
            }
        )
    }

    public subscript<Subject: ExpressibleByDictionaryLiteral>(
        dynamicMember keyPath: WritableKeyPath<Value, Subject>
    ) -> ViewBinding<Subject?> {
        ViewBinding<Subject?>(
            get: { get()[keyPath: keyPath] },
            set: { newValue in
                var value = get()

                value[keyPath: keyPath] = newValue ?? [:]

                set(value)
            }
        )
    }

    public subscript<Subject: Hashable>(
        dynamicMember keyPath: WritableKeyPath<Value, Subject?>
    ) -> ViewFocusBinding<Subject?> {
        ViewFocusBinding(binding: self[dynamicMember: keyPath])
    }

    public subscript(
        dynamicMember keyPath: WritableKeyPath<Value, Bool>
    ) -> ViewFocusBinding<Bool> {
        ViewFocusBinding(binding: self[dynamicMember: keyPath])
    }
}

extension ViewBinding where
    Value: Changeable,
    Value.ChangeableCopy == Value {

    @_disfavoredOverload
    public subscript<Subject>(
        dynamicMember keyPath: WritableKeyPath<Value, Subject>
    ) -> ViewBinding<Subject> {
        ViewBinding<Subject>(
            get: { get()[keyPath: keyPath] },
            set: { set(get().changing(keyPath, to: $0)) }
        )
    }

    @_disfavoredOverload
    public subscript<Subject: ExpressibleByStringLiteral>(
        dynamicMember keyPath: WritableKeyPath<Value, Subject>
    ) -> ViewBinding<Subject?> {
        ViewBinding<Subject?>(
            get: { get()[keyPath: keyPath] },
            set: { set(get().changing(keyPath, to: $0 ?? "")) }
        )
    }

    @_disfavoredOverload
    public subscript<Subject: ExpressibleByArrayLiteral>(
        dynamicMember keyPath: WritableKeyPath<Value, Subject>
    ) -> ViewBinding<Subject?> {
        ViewBinding<Subject?>(
            get: { get()[keyPath: keyPath] },
            set: { set(get().changing(keyPath, to: $0 ?? [])) }
        )
    }

    @_disfavoredOverload
    public subscript<Subject: ExpressibleByDictionaryLiteral>(
        dynamicMember keyPath: WritableKeyPath<Value, Subject>
    ) -> ViewBinding<Subject?> {
        ViewBinding<Subject?>(
            get: { get()[keyPath: keyPath] },
            set: { set(get().changing(keyPath, to: $0 ?? [:])) }
        )
    }

    @_disfavoredOverload
    public subscript<Subject: Hashable>(
        dynamicMember keyPath: WritableKeyPath<Value, Subject?>
    ) -> ViewFocusBinding<Subject?> {
        ViewFocusBinding(binding: self[dynamicMember: keyPath])
    }

    @_disfavoredOverload
    public subscript(
        dynamicMember keyPath: WritableKeyPath<Value, Bool>
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

extension ViewBinding: @unchecked Sendable where Value: Sendable { }
#endif
