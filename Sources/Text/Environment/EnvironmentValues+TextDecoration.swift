#if canImport(UIKit)
import SwiftUI

internal struct TextDecorationKey: EnvironmentKey {

    internal static let defaultValue: [AnyTextDecorator] = []
}

extension EnvironmentValues {

    public var textDecoration: [AnyTextDecorator] {
        get { self[TextDecorationKey.self] }
        set { self[TextDecorationKey.self] = newValue }
    }
}

extension View {

    public nonisolated func textDecoration(_ decoration: [AnyTextDecorator]) -> some View {
        environment(\.textDecoration, decoration)
    }
}
#endif
