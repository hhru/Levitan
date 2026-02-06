#if canImport(UIKit)
import SwiftUI

internal struct ComponentHostingRoot<Content: View>: View {

    internal let content: Content
    internal var context: ComponentContext

    @Environment(\.self)
    private var environment: EnvironmentValues

    internal var body: some View {
        let environment = context.resolveEnvironment(environment)

        let theme = environment
            .componentViewController?
            .view
            .tokens
            .theme

        content
            .iflet(theme) { $0.tokenThemeKey($1.key) }
            .iflet(theme) { $0.tokenThemeScheme($1.scheme) }
            .environment(\.self, environment)
    }
}
#endif
