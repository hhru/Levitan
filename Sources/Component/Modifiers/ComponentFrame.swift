#if canImport(UIKit)
import SwiftUI

/// Данные для определения размеров и положения UI-представления в контейнере.
///
/// Также реализует протоколы `ViewModifier` и `ComponentModifier`
/// и может быть использован для модификации компонентов.
///
/// - SeeAlso: ``ComponentModifier``
/// - SeeAlso: ``ComponentSizing``
/// - SeeAlso: ``Component``
public struct ComponentFrame: Equatable, Sendable {

    /// Данные для определения размеров.
    public let sizing: ComponentSizing

    /// Выравнивание относительно контейнера.
    ///
    /// Большинство значений этого свойства не оказывают заметного влияния,
    /// когда размер контейнера совпадает с размером контента.
    public let alignment: Alignment

    /// Создает данные для определения размеров и положения UI-представления в контейнере.
    ///
    /// - Parameters:
    ///   - sizing: Данные для определения размеров.
    ///   - alignment: Выравнивание относительно контейнера.
    public init(
        sizing: ComponentSizing,
        alignment: Alignment = .center
    ) {
        self.sizing = sizing
        self.alignment = alignment
    }
}

extension ComponentFrame: ViewModifier {

    public func body(content: Content) -> some View {
        switch (sizing.width, sizing.height) {
        case let (.fixed(width), .fixed(height)):
            content.frame(width: width, height: height, alignment: alignment)

        case let (.fixed(width), .hug(isHeightForced)):
            content
                .fixedSize(horizontal: false, vertical: isHeightForced)
                .frame(width: width, alignment: alignment)

        case let (.fixed(width), .fill):
            content
                .frame(maxHeight: .infinity, alignment: alignment)
                .frame(width: width, alignment: alignment)

        case let (.hug(isWidthForced), .hug(isHeightForced)):
            content.fixedSize(horizontal: isWidthForced, vertical: isHeightForced)

        case let (.hug(isWidthForced), .fixed(height)):
            content
                .fixedSize(horizontal: isWidthForced, vertical: false)
                .frame(height: height, alignment: alignment)

        case let (.hug(isWidthForced), .fill):
            content
                .fixedSize(horizontal: isWidthForced, vertical: false)
                .frame(maxHeight: .infinity, alignment: alignment)

        case (.fill, .fill):
            content.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)

        case let (.fill, .fixed(height)):
            content
                .frame(maxWidth: .infinity, alignment: alignment)
                .frame(height: height, alignment: alignment)

        case let (.fill, .hug(isHeightForced)):
            content
                .fixedSize(horizontal: false, vertical: isHeightForced)
                .frame(maxWidth: .infinity, alignment: alignment)
        }
    }
}

extension ComponentFrame: ComponentModifier {

    public func sizing<Content: Component>(
        content: Content,
        fitting size: CGSize,
        context: ComponentContext
    ) -> ComponentSizing {
        sizing
    }
}

extension View {

    /// Помещает UI-представление в контейнер с заданными размерами и выравниванием.
    ///
    /// - Parameters:
    ///   - sizing: Данные для определения размеров.
    ///   - alignment: Выравнивание относительно контейнера.
    /// - Returns: Контейнер для переопределения размеров и положения UI-представления.
    ///
    /// - SeeAlso: ``ComponentFrame``
    /// - SeeAlso: ``ComponentSizing``
    /// - SeeAlso: ``ComponentSizingStrategy``
    public nonisolated func frame(
        sizing: ComponentSizing,
        alignment: Alignment = .topLeading
    ) -> ModifiedContent<Self, ComponentFrame> {
        modifier(ComponentFrame(sizing: sizing, alignment: alignment))
    }

    /// Помещает UI-представление в контейнер с заданными размерами и выравниванием.
    ///
    /// - Parameters:
    ///   - width: Стратегия определения ширины компонента.
    ///   - height: Стратегия определения высоты компонента.
    ///   - alignment: Выравнивание контента относительно контейнера.
    /// - Returns: Контейнер для переопределения размеров и положения UI-представления.
    ///
    /// - SeeAlso: ``ComponentFrame``
    /// - SeeAlso: ``ComponentSizing``
    /// - SeeAlso: ``ComponentSizingStrategy``
    public nonisolated func frame(
        width: ComponentSizingStrategy = .hug,
        height: ComponentSizingStrategy = .hug,
        alignment: Alignment = .topLeading
    ) -> ModifiedContent<Self, ComponentFrame> {
        frame(
            sizing: ComponentSizing(
                width: width,
                height: height
            ),
            alignment: alignment
        )
    }

    /// Помещает UI-представление в контейнер с заданными размерами и выравниванием.
    ///
    /// - Parameters:
    ///   - width: Фиксированная ширина компонента.
    ///   - height: Стратегия определения высоты компонента.
    ///   - alignment: Выравнивание контента относительно контейнера.
    /// - Returns: Контейнер для переопределения размеров и положения UI-представления.
    ///
    /// - SeeAlso: ``ComponentFrame``
    /// - SeeAlso: ``ComponentSizing``
    /// - SeeAlso: ``ComponentSizingStrategy``
    public nonisolated func frame(
        width: CGFloat,
        height: ComponentSizingStrategy = .hug,
        alignment: Alignment = .topLeading
    ) -> ModifiedContent<Self, ComponentFrame> {
        frame(
            sizing: ComponentSizing(
                width: width,
                height: height
            ),
            alignment: alignment
        )
    }

    /// Помещает UI-представление в контейнер с заданными размерами и выравниванием.
    ///
    /// - Parameters:
    ///   - width: Стратегия определения ширины компонента.
    ///   - height: Фиксированная высота компонента.
    ///   - alignment: Выравнивание контента относительно контейнера.
    /// - Returns: Контейнер для переопределения размеров и положения UI-представления.
    ///
    /// - SeeAlso: ``ComponentFrame``
    /// - SeeAlso: ``ComponentSizing``
    /// - SeeAlso: ``ComponentSizingStrategy``
    public nonisolated func frame(
        width: ComponentSizingStrategy = .hug,
        height: CGFloat,
        alignment: Alignment = .topLeading
    ) -> ModifiedContent<Self, ComponentFrame> {
        frame(
            sizing: ComponentSizing(
                width: width,
                height: height
            ),
            alignment: alignment
        )
    }
}

extension View where Self: Equatable {

    /// Помещает UI-представление в контейнер с заданными размерами и выравниванием.
    ///
    /// - Parameters:
    ///   - width: Фиксированная ширина компонента.
    ///   - height: Фиксированная высота компонента.
    ///   - alignment: Выравнивание контента относительно контейнера.
    /// - Returns: Контейнер для переопределения размеров и положения UI-представления.
    ///
    ///
    /// - SeeAlso: ``ComponentFrame``
    /// - SeeAlso: ``ComponentSizing``
    /// - SeeAlso: ``ComponentSizingStrategy``
    public nonisolated func frame(
        width: CGFloat,
        height: CGFloat,
        alignment: Alignment = .topLeading
    ) -> ModifiedContent<Self, ComponentFrame> {
        frame(
            sizing: ComponentSizing(
                width: width,
                height: height
            ),
            alignment: alignment
        )
    }
}
#endif
