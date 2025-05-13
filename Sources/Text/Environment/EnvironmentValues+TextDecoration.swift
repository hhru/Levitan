#if canImport(UIKit)
import SwiftUI

internal struct TextDecorationKey: EnvironmentKey {

    internal static var defaultValue: [AnyTextDecorator] {
        []
    }
}

extension EnvironmentValues {

    public var textDecoration: [AnyTextDecorator] {
        get { self[TextDecorationKey.self] }
        set { self[TextDecorationKey.self] = newValue }
    }
}
#endif
