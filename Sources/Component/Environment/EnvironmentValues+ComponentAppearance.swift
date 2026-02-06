#if canImport(UIKit)
import SwiftUI

internal struct ComponentAppearanceEnvironmentKey: EnvironmentKey {

    internal static let defaultValue: ComponentSuperviewAppearance = ComponentAppearance()
}

extension EnvironmentValues {

    public var componentSuperviewAppearance: ComponentSuperviewAppearance {
        get { self[ComponentAppearanceEnvironmentKey.self] }
        set { self[ComponentAppearanceEnvironmentKey.self] = newValue }
    }
}

extension ComponentContext {

    @MainActor
    public func componentAppearance(
        _ appearance: ComponentAppearance,
        of view: ComponentAppearanceView
    ) -> Self {
        self.componentSuperviewAppearance.connectAppearance(
            appearance,
            of: view
        )

        return self.componentSuperviewAppearance(appearance)
    }
}
#endif
