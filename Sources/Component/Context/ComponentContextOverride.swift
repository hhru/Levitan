import SwiftUI

internal struct ComponentContextOverride {

    internal let value: Any

    private let overrider: (_ environment: inout EnvironmentValues) -> Void

    internal init<Value>(keyPath: WritableKeyPath<EnvironmentValues, Value>, value: Value) {
        self.value = value

        overrider = { values in
            values[keyPath: keyPath] = value
        }
    }

    internal func override(for environment: inout EnvironmentValues) {
        overrider(&environment)
    }
}
