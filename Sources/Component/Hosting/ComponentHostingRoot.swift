#if canImport(UIKit)
import SwiftUI

internal struct ComponentHostingRoot<Content: View>: View {

    internal var content: Content
    internal var context: ComponentContext

    @Environment(\.self)
    private var environment: EnvironmentValues

    private var contentEnvironment: EnvironmentValues {
        let environment = context.hostingEnvironment ?? environment

        return context
            .overrides
            .values
            .reduce(into: environment) { $1.override(for: &$0) }
    }

    internal var body: some View {
        let contentEnvironment = contentEnvironment

        let componentView = contentEnvironment
            .componentViewControllerProvider()?
            .view

        let themeManager = componentView?.tokens.themeManager
        let theme = componentView?.tokens.theme

        content
            .iflet(theme) { $0.tokenThemeKey($1.key) }
            .iflet(theme) { $0.tokenThemeScheme($1.scheme) }
            .iflet(themeManager) { $0.tokenThemeManager($1) }
            .environment(\.self, contentEnvironment)
    }
}
#endif
