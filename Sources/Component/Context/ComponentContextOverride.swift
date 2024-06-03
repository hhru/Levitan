import SwiftUI

internal struct ComponentContextOverride {

    private let storage: EnvironmentValues
    private let keyPath: AnyKeyPath

    private let overrider: (_ environment: inout EnvironmentValues) -> Void

    internal var value: Any? {
        storage[keyPath: keyPath]
    }

    internal init<Value>(keyPath: WritableKeyPath<EnvironmentValues, Value>, value: Value) {
        var storage = EnvironmentValues()

        storage[keyPath: keyPath] = value

        self.storage = storage
        self.keyPath = keyPath

        overrider = { values in
            values[keyPath: keyPath] = storage[keyPath: keyPath]
        }
    }

    internal func override(for environment: inout EnvironmentValues) {
        overrider(&environment)
    }
}
