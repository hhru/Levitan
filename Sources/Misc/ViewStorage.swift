import Foundation

@propertyWrapper
public final class ViewStorage<Value> {

    public var value: Value

    public var wrappedValue: Value {
        get { value }
        set { value = newValue }
    }

    public var projectedValue: ViewBinding<Value> {
        ViewBinding<Value>(
            getter: { self.value },
            setter: { self.value = $0 }
        )
    }

    public init(_ value: Value) {
        self.value = value
    }

    public convenience init(wrappedValue: Value) {
        self.init(wrappedValue)
    }
}
