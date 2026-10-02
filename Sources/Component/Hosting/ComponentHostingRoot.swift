#if canImport(UIKit)
import SwiftUI

internal struct ComponentHostingRoot<Content: View>: View {

    internal let content: Content
    internal var context: ComponentContext

    internal var body: some View {
        let theme = context
            .componentViewController?
            .view
            .tokens
            .theme

        content
            .iflet(theme) { $0.tokenThemeKey($1.key) }
            .iflet(theme) { $0.tokenThemeScheme($1.scheme) }
            .transformEnvironment(\.self) { environment in
                environment = context.resolveEnvironment(environment)
            }
    }
}
#endif
