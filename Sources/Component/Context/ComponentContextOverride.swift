#if canImport(UIKit)
import SwiftUI

internal struct ComponentContextOverride {

    private let overrider: (_ environment: inout EnvironmentValues) -> Void

    internal init<Value>(keyPath: WritableKeyPath<EnvironmentValues, Value>, value: Value) {
        overrider = { environment in
            environment[keyPath: keyPath] = value
        }
    }

    internal func override(for environment: inout EnvironmentValues) {
        overrider(&environment)
    }
}
#endif
