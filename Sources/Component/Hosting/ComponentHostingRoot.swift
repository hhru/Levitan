#if canImport(UIKit)
import SwiftUI

internal struct ComponentHostingRoot<Content: View>: View {

    internal let content: Content
    internal var context: ComponentContext

    internal var body: some View {
        // Не через context.componentViewController: до iOS 27 это чтение протекает в окружение
        // внешнего хостинга, см. ComponentHostingNestingTests.
        let theme = context
            .resolveEnvironment(EnvironmentValues())
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
