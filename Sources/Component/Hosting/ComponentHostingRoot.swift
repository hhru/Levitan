#if canImport(UIKit)
import SwiftUI

internal struct ComponentHostingRoot<Content: View>: View {

    internal let content: Content
    internal let context: ComponentContext

    internal let viewControllerProvider: @MainActor () -> UIViewController?

    internal var body: some View {
        let theme = viewControllerProvider()?
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
