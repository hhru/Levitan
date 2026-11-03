#if canImport(UIKit)
import SwiftUI

internal struct ComponentHostingRoot<Content: View>: View {

    internal let id: ComponentID?

    internal let content: Content
    internal let context: ComponentContext

    internal var theme: TokenTheme

    internal var body: some View {
        content
            .transition(.identity)
            .id(id)
            .tokenThemeKey(theme.key)
            .tokenThemeScheme(theme.scheme)
            .transformEnvironment(\.self) { environment in
                environment = context.resolveEnvironment(environment)
            }
    }
}
#endif
