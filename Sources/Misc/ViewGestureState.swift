#if canImport(UIKit)
import SwiftUI

@propertyWrapper
public struct ViewGestureState<Value> {

    private var state: GestureState<Value>

    public var wrappedValue: Value {
        state.wrappedValue
    }

    public var projectedValue: GestureState<Value> {
        state.projectedValue
    }

    public init(wrappedValue: Value) {
        state = GestureState(wrappedValue: wrappedValue)
    }

    public init(initialValue: Value) {
        state = GestureState(initialValue: initialValue)
    }

    public init(
        wrappedValue: Value,
        resetTransaction: Transaction
    ) {
        state = GestureState(
            wrappedValue: wrappedValue,
            resetTransaction: resetTransaction
        )
    }

    public init(
        initialValue: Value,
        resetTransaction: Transaction
    ) {
        state = GestureState(
            initialValue: initialValue,
            resetTransaction: resetTransaction
        )
    }

    public init(
        wrappedValue: Value,
        reset: @escaping (Value, inout Transaction) -> Void
    ) {
        state = GestureState(
            wrappedValue: wrappedValue,
            reset: reset
        )
    }

    public init(
        initialValue: Value,
        reset: @escaping (Value, inout Transaction) -> Void
    ) {
        state = GestureState(
            initialValue: initialValue,
            reset: reset
        )
    }
}

extension ViewGestureState where Value: ExpressibleByNilLiteral {

    public init(resetTransaction: Transaction = Transaction()) {
        state = GestureState(resetTransaction: resetTransaction)
    }

    public init(reset: @escaping (Value, inout Transaction) -> Void) {
        state = GestureState(reset: reset)
    }
}

extension ViewGestureState: DynamicProperty {

    public mutating func update() {
        state.update()
    }
}

extension ViewGestureState: Equatable where Value: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        true
    }
}

extension ViewGestureState: Hashable where Value: Hashable {

    public func hash(into hasher: inout Hasher) { }
}

extension ViewGestureState: Sendable where Value: Sendable { }
#endif
