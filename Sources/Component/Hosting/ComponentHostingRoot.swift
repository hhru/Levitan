#if canImport(UIKit)
import SwiftUI

internal struct ComponentHostingRoot<Content: View>: View {

    internal let content: Content
    internal var context: ComponentContext

    internal var body: some View {
        // Контроллер берется только из переопределений: чтение окружения внешнего хостинга
        // из контекста в iOS 26 протекает обратно в это окружение, и родительский компонент
        // получает вложенный UIHostingController, добавляя его дочерним самому себе.
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
