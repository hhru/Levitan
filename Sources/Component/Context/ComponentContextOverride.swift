#if canImport(UIKit1)
import SwiftUI

internal struct ComponentContextOverride {

    private let overrider: (_ environment: inout EnvironmentValues) -> Void
    private let resolver: () -> Any?

    internal var value: Any? {
        resolver()
    }

    internal init<Value>(keyPath: WritableKeyPath<EnvironmentValues, Value>, value: Value) {
        var storage = EnvironmentValues()

        storage[keyPath: keyPath] = value

        overrider = { values in
            values[keyPath: keyPath] = storage[keyPath: keyPath]
        }

        resolver = { storage[keyPath: keyPath] }
    }

    internal func override(for environment: inout EnvironmentValues) {
        overrider(&environment)
    }
}
#endif
