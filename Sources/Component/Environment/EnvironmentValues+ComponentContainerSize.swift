import SwiftUI

internal struct ComponentContainerSizeKey: EnvironmentKey {

    internal static let defaultValue = CGSize(
        width: CGFloat.infinity,
        height: CGFloat.infinity
    )
}

extension EnvironmentValues {

    /// Размеры ближайшего известного контейнера.
    ///
    /// Используется в качестве ограничивающих размеров для определения размеров самих компонентов
    /// при встраивании UIKit-компонента в SwiftUI-представление.
    ///
    /// Значением по умолчанию является размер с бесконечной шириной и высотой.
    ///
    /// - Note: Нет необходимости самостоятельно устанавливать значение для этой переменной,
    ///         его переопределяют встроенные компоненты.
    public var componentContainerSize: CGSize {
        get { self[ComponentContainerSizeKey.self] }
        set { self[ComponentContainerSizeKey.self] = newValue }
    }
}
