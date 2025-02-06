#if canImport(UIKit1)
import SwiftUI

internal struct ComponentHostingRoot<Content: View>: View {

    internal let content: Content?
    internal let context: ComponentContext?

    @Environment(\.self)
    private var environment: EnvironmentValues

    private var contentEnvironment: EnvironmentValues {
        guard let context else {
            return environment
        }

        let environment = context.environment ?? environment

        return context
            .overrides
            .values
            .reduce(into: environment) { $1.override(for: &$0) }
    }

    internal var body: some View {
        let componentIdentifier = context?.componentIdentifier

        let componentView = context?
            .componentViewController?
            .view

        let themeManager = componentView?.tokens.themeManager
        let theme = componentView?.tokens.theme

        content?
            .iflet(componentIdentifier) { $0.id($1) }
            .iflet(theme) { $0.tokenThemeKey($1.key) }
            .iflet(theme) { $0.tokenThemeScheme($1.scheme) }
            .iflet(themeManager) { $0.tokenThemeManager($1) }
            .environment(\.self, contentEnvironment)
    }
}
#endif
