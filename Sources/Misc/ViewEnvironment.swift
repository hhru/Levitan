import SwiftUI

// TODO: Добавить документацию
@propertyWrapper
public struct ViewEnvironment<Value>: DynamicProperty {

    private let keyPath: KeyPath<EnvironmentValues, Value>
    private var forcedValue: Value?

    private var environment: Environment<Value>

    public var wrappedValue: Value {
        forcedValue ?? environment.wrappedValue
    }

    public var projectedValue: Value? {
        get { forcedValue }
        set { forcedValue = newValue }
    }

    public init(
        _ keyPath: KeyPath<EnvironmentValues, Value>,
        forcedValue: Value? = nil
    ) {
        self.keyPath = keyPath
        self.forcedValue = forcedValue

        environment = Environment(keyPath)
    }

    public mutating func update() {
        environment.update()
    }
}

extension ViewEnvironment: Equatable where Value: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.forcedValue == rhs.forcedValue
    }
}

extension ViewEnvironment: Hashable where Value: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(forcedValue)
    }
}
