#if canImport(UIKit)
import SwiftUI

internal struct ComponentSuperviewObservatoryEnvironmentKey: EnvironmentKey {

    internal static var defaultValue: ComponentSuperviewObservatory? {
        nil
    }
}

extension EnvironmentValues {

    public var componentSuperviewObservatory: ComponentSuperviewObservatory? {
        get { self[ComponentSuperviewObservatoryEnvironmentKey.self] }
        set { self[ComponentSuperviewObservatoryEnvironmentKey.self] = newValue }
    }
}
#endif
