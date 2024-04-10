import Foundation

/// Данные для определения размеров компонента.
///
/// Используется в Lazy-контейнере (например, коллекции)
/// или при встраивании UIKit-компонента в SwiftUI-представление.
///
/// - SeeAlso: ``ComponentSizingStrategy``
/// - SeeAlso: ``Component``
public struct ComponentSizing: Equatable {

    /// Стратегия определения ширины компонента.
    public let width: ComponentSizingStrategy

    /// Стратегия определения высоты компонента.
    public let height: ComponentSizingStrategy

    /// Создает данные для определения размеров компонента.
    ///
    /// - Parameters:
    ///   - width: Стратегия определения ширины компонента.
    ///   - height: Стратегия определения высоты компонента.
    public init(
        width: ComponentSizingStrategy,
        height: ComponentSizingStrategy
    ) {
        self.width = width
        self.height = height
    }
}
