#if canImport(UIKit)
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

    /// Создает данные для определения размеров компонента.
    ///
    /// - Parameters:
    ///   - width: Фиксированная ширина компонента.
    ///   - height: Стратегия определения высоты компонента.
    public init(
        width: CGFloat,
        height: ComponentSizingStrategy
    ) {
        self.init(
            width: .fixed(width),
            height: height
        )
    }

    /// Создает данные для определения размеров компонента.
    ///
    /// - Parameters:
    ///   - width: Стратегия определения ширины компонента.
    ///   - height: Фиксированная высота компонента.
    public init(
        width: ComponentSizingStrategy,
        height: CGFloat
    ) {
        self.init(
            width: width,
            height: .fixed(height)
        )
    }

    /// Создает данные для определения размеров компонента.
    ///
    /// - Parameters:
    ///   - width: Фиксированная ширина компонента.
    ///   - height: Фиксированная высота компонента.
    public init(
        width: CGFloat,
        height: CGFloat
    ) {
        self.init(
            width: .fixed(width),
            height: .fixed(height)
        )
    }

    /// Создает данные для определения размеров компонента.
    ///
    /// - Parameters:
    ///   - size: Фиксированные размеры компонента.
    public init(size: CGSize) {
        self.init(
            width: .fixed(size.width),
            height: .fixed(size.height)
        )
    }
}
#endif
