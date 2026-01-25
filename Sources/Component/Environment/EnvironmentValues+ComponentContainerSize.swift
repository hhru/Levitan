#if canImport(UIKit)
import SwiftUI

internal struct ComponentContainerSizeKey: EnvironmentKey {

    internal static let defaultValue: CGSize? = nil
}

extension EnvironmentValues {

    /// Размеры ближайшего известного контейнера.
    ///
    /// Может использоваться в качестве максимальных размеров для определения размеров компонента
    /// в методе `sizing(fitting:context:)`.
    public var componentContainerSize: CGSize? {
        get { self[ComponentContainerSizeKey.self] }
        set { self[ComponentContainerSizeKey.self] = newValue }
    }
}

extension View {

    /// Устанавливает размеры ближайшего известного контейнера в окружении.
    ///
    /// Может использоваться в качестве максимальных размеров для определения размеров компонента
    /// в методе `sizing(fitting:context:)`.
    public nonisolated func componentContainerSize(_ containerSize: CGSize?) -> some View {
        environment(\.componentContainerSize, containerSize)
    }
}
#endif
