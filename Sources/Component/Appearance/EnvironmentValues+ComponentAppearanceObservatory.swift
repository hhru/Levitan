#if canImport(UIKit)
import SwiftUI

internal struct ComponentAppearanceObservatoryEnvironmentKey: EnvironmentKey {

    internal static var defaultValue: ComponentAppearanceObservatory? {
        nil
    }
}

extension EnvironmentValues {

    public var componentAppearanceObservatory: ComponentAppearanceObservatory? {
        get { self[ComponentAppearanceObservatoryEnvironmentKey.self] }
        set { self[ComponentAppearanceObservatoryEnvironmentKey.self] = newValue }
    }
}
#endif
