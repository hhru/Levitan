#if canImport(UIKit1)
import SwiftUI

internal struct TextTypographyKey: EnvironmentKey {

    internal static let defaultValue = TypographyToken(
        font: .system(size: 17.0)
    )
}

extension EnvironmentValues {

    public var textTypography: TypographyToken {
        get { self[TextTypographyKey.self] }
        set { self[TextTypographyKey.self] = newValue }
    }
}
#endif
