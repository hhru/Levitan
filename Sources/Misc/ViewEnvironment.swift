import SwiftUI

// TODO: Добавить документацию
@propertyWrapper
public struct ViewEnvironment<Value> {

    private var environment: Environment<Value>

    public var wrappedValue: Value {
        environment.wrappedValue
    }

    public init(_ keyPath: KeyPath<EnvironmentValues, Value>) {
        environment = Environment(keyPath)
    }
}

extension ViewEnvironment: DynamicProperty {

    public mutating func update() {
        environment.update()
    }
}

extension ViewEnvironment: Sendable where Value: Sendable { }

extension ViewEnvironment: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        true
    }
}

extension ViewEnvironment: Hashable {

    public func hash(into hasher: inout Hasher) { }
}
