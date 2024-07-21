import Foundation

// TODO: Добавить документацию
@dynamicMemberLookup
@propertyWrapper
public struct ViewBindable<Value>: CustomStringConvertible {

    private final class Storage {

        fileprivate var value: Value

        fileprivate init(value: Value) {
            self.value = value
        }
    }

    private let storage: Storage

    public var wrappedValue: Value {
        get { storage.value }
        nonmutating set { storage.value = newValue }
    }

    public var projectedValue: Self {
        self
    }

    public var description: String {
        String(describing: wrappedValue)
    }

    public init(_ value: Value) {
        self.storage = Storage(value: value)
    }

    public init(wrappedValue: Value) {
        self.init(wrappedValue)
    }

    public init(projectedValue: Self) {
        self = projectedValue
    }

    public subscript<Subject>(
        dynamicMember keyPath: WritableKeyPath<Value, Subject>
    ) -> ViewBinding<Subject> {
        ViewBinding<Subject>(
            get: { wrappedValue[keyPath: keyPath] },
            set: { wrappedValue[keyPath: keyPath] = $0 }
        )
    }
}
