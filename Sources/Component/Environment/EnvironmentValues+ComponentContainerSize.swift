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
    ///
    /// Значением по умолчанию является размеры ближайшего экземпляра `UIViewController` в окружении,
    /// либо размеры основного экрана устройства.
    ///
    /// - Note: Нет необходимости самостоятельно устанавливать значение для этой переменной,
    ///         его переопределяют встроенные компоненты.
    public var componentContainerSize: CGSize? {
        get { self[ComponentContainerSizeKey.self] }
        set { self[ComponentContainerSizeKey.self] = newValue }
    }
}
#endif
