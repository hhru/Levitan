#if canImport(UIKit)
import SwiftUI

internal struct ComponentContainerSizeKey: EnvironmentKey {

    internal static let defaultValue: CGSize = .zero
}

extension EnvironmentValues {

    /// Размеры ближайшего известного контейнера.
    ///
    /// Может использоваться в качестве максимальных размеров для определения размеров компонента
    /// в методе `sizing(fitting:context:)`.
    public var componentContainerSize: CGSize {
        get { self[ComponentContainerSizeKey.self] }
        set { self[ComponentContainerSizeKey.self] = newValue }
    }
}

extension View {

    /// Устанавливает размеры ближайшего известного контейнера.
    ///
    /// Может использоваться в качестве максимальных размеров для определения размеров компонента
    /// в методе `sizing(fitting:context:)`.
    ///
    /// - Parameter size: Размеры ближайшего известного контейнера.
    /// - Returns: Модифицированный экземпляр UI-представления.
    public nonisolated func componentContainerSize(_ size: CGSize) -> some View {
        environment(\.componentContainerSize, size)
    }
}
#endif
