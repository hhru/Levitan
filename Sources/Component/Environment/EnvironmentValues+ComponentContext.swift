#if canImport(UIKit1)
import SwiftUI

extension EnvironmentValues {

    /// Контекст компонентов целиком.
    ///
    /// Позволяет получить в SwiftUI-представлениях контекст компонентов,
    /// например, чтобы определить их размер.
    public var componentContext: ComponentContext {
        ComponentContext(
            environment: self,
            overrides: [:]
        )
    }
}
#endif
