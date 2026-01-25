#if canImport(UIKit)
import SwiftUI

internal struct ComponentContextOverride {

    internal let value: Any
    internal let overrider: (_ environment: inout EnvironmentValues) -> Void

    internal init(
        _ value: Any,
        overrider: @escaping (_ environment: inout EnvironmentValues) -> Void
    ) {
        self.value = value
        self.overrider = overrider
    }

    internal init<Value>(
        keyPath: WritableKeyPath<EnvironmentValues, Value>,
        value: Value
    ) {
        self.init(value) { environment in
            environment[keyPath: keyPath] = value
        }
    }
}
#endif
