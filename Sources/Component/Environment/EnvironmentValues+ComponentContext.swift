#if canImport(UIKit)
import SwiftUI

extension EnvironmentValues {

    /// Контекст компонентов целиком.
    ///
    /// Позволяет получить в SwiftUI-представлениях контекст компонентов,
    /// например, чтобы определить их размер.
    public var componentContext: ComponentContext {
        ComponentContext(
            hostingEnvironment: self,
            defaultEnvironment: self,
            overrides: [:]
        )
    }
}
#endif
