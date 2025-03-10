#if canImport(UIKit)
import Foundation

// TODO: Добавить документацию
@dynamicMemberLookup
@propertyWrapper
public struct ViewBindable<Value> {

    private var value: Value

    public var wrappedValue: Value {
        get { value }
        set { value = newValue }
    }

    public var projectedValue: Self {
        self
    }

    public init(_ value: Value)
    where Value: AnyObject {
        self.value = value
    }

    public init(wrappedValue: Value)
    where Value: AnyObject {
        self.init(wrappedValue)
    }

    public init(projectedValue: Self)
    where Value: AnyObject {
        self = projectedValue
    }

    public subscript<Subject>(
        dynamicMember keyPath: ReferenceWritableKeyPath<Value, Subject>
    ) -> ViewBinding<Subject> {
        ViewBinding<Subject>(
            get: { wrappedValue[keyPath: keyPath] },
            set: { wrappedValue[keyPath: keyPath] = $0 }
        )
    }
}

extension ViewBindable: Equatable where Value: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}

extension ViewBindable: Hashable where Value: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(wrappedValue)
    }
}
#endif
