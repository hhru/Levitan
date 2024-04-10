import SwiftUI

// TODO: Дополнить документацию

/// Данные для определения размеров и положения компонента в контейнере.
///
/// Также реализует протокол `ComponentModifier`
/// и может быть использован для модификации любых SwiftUI-представлений.
///
/// - SeeAlso: ``ComponentSizing``
/// - SeeAlso: ``ComponentModifier``
/// - SeeAlso: ``Component``
/// - SeeAlso: ``Alignment``
public struct ComponentFrame {

    /// Данные для определения размеров.
    public let sizing: ComponentSizing

    /// Выравнивание относительно контейнера.
    ///
    /// Большинство значений этого свойства не оказывают заметного влияния,
    /// когда размер контейнера совпадает с размером контента.
    public let alignment: Alignment

    /// Данные для определения размеров и положения компонента в контейнере.
    ///
    /// - Parameters:
    ///   - sizing: Данные для определения размеров.
    ///   - alignment: Выравнивание относительно контейнера.
    public init(
        sizing: ComponentSizing,
        alignment: Alignment
    ) {
        self.sizing = sizing
        self.alignment = alignment
    }
}

extension ComponentFrame: ComponentModifier {

    public func body(content: Content) -> some View {
        switch (sizing.width, sizing.height) {
        case let (.fixed(width), .fixed(height)):
            content.frame(width: width, height: height, alignment: alignment)

        case let (.fixed(width), .hug):
            content.frame(width: width, alignment: alignment)

        case let (.hug, .fixed(height)):
            content.frame(height: height, alignment: alignment)

        case let (.fixed(width), .fill):
            content
                .frame(maxHeight: .infinity, alignment: alignment)
                .frame(width: width, alignment: alignment)

        case let (.fill, .fixed(height)):
            content
                .frame(maxWidth: .infinity, alignment: alignment)
                .frame(height: height, alignment: alignment)

        case (.hug, .hug):
            content

        case (.hug, .fill):
            content.frame(maxHeight: .infinity, alignment: alignment)

        case (.fill, .hug):
            content.frame(maxWidth: .infinity, alignment: alignment)

        case (.fill, .fill):
            content.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
        }
    }

    public func sizing<Content: Component>(
        content: Content,
        fitting size: CGSize,
        context: ComponentContext
    ) -> ComponentSizing {
        sizing
    }
}

extension View {

    /// Помещает UI-представление в невидимый контейнер с заданными размерами и выравниванием.
    ///
    /// - Parameters:
    ///   - sizing: Данные для определения итоговых размеров.
    ///   - alignment: Выравнивание контента относительно контейнера.
    /// - Returns: Контейнер для расположения контента с заданными размерами.
    ///
    /// - SeeAlso: ``ComponentFrame``
    /// - SeeAlso: ``ComponentSizing``
    /// - SeeAlso: ``ComponentSizingStrategy``
    public func frame(
        sizing: ComponentSizing,
        alignment: Alignment = .topLeading
    ) -> ModifiedContent<Self, ComponentFrame> {
        modifier(ComponentFrame(sizing: sizing, alignment: alignment))
    }

    /// Помещает UI-представление в невидимый контейнер с заданными размерами и выравниванием.
    ///
    /// - Parameters:
    ///   - width: Стратегия определения ширины компонента.
    ///   - height: Стратегия определения высоты компонента.
    ///   - alignment: Выравнивание контента относительно контейнера.
    /// - Returns: Контейнер для расположения контента с заданными размерами.
    ///
    /// - SeeAlso: ``Frame``
    /// - SeeAlso: ``ComponentSizing``
    /// - SeeAlso: ``ComponentSizingStrategy``
    public func frame(
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
}
