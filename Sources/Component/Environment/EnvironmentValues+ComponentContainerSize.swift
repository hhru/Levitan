import SwiftUI
import UIKit

internal struct ComponentContainerSizeKey: EnvironmentKey {

    internal static let defaultValue = UIScreen.main.bounds.size
}

extension EnvironmentValues {

    /// Размеры ближайшего известного контейнера .
    ///
    /// Используется в качестве ограничивающих размеров для определения размеров самих компонентов
    /// при встраивании UIKit-компонента в SwiftUI-представление.
    ///
    /// Значением по умолчанию является размер основного экрана устройства.
    ///
    /// - Note: Нет необходимости самостоятельно устанавливать значение для этой переменной,
    ///         его переопределяют встроенные компоненты.
    public var componentContainerSize: CGSize {
        get { self[ComponentContainerSizeKey.self] }
        set { self[ComponentContainerSizeKey.self] = newValue }
    }
}
