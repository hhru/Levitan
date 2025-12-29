#if canImport(UIKit)
import SwiftUI

internal struct ComponentContextValue {

    internal let value: Any
    internal let overrider: ((_ environment: inout EnvironmentValues) -> Void)?

    private init(
        _ value: Any,
        overrider: ((_ environment: inout EnvironmentValues) -> Void)?
    ) {
        self.value = value
        self.overrider = overrider
    }

    internal init<Value>(
        _ value: Value,
        at keyPath: WritableKeyPath<EnvironmentValues, Value>
    ) {
        self.init(value) { environment in
            environment[keyPath: keyPath] = value
        }
    }

    internal init<Value>(
        _ value: Value,
        at keyPath: KeyPath<EnvironmentValues, Value>
    ) {
        if let keyPath = keyPath as? WritableKeyPath {
            self.init(value, at: keyPath)
        } else {
            self.init(value, overrider: nil)
        }
    }
}
#endif
