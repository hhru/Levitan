#if canImport(UIKit)
import SwiftUI

/// Контейнер для переопределения размеров и положения компонентов.
///
/// - SeeAlso: ``ComponentSizing``
/// - SeeAlso: ``Component``
public struct ComponentFrame<Content: View> {

    /// Компонент, который будет обернут в контейнер.
    public let content: Content

    /// Данные для определения размеров.
    public let sizing: ComponentSizing

    /// Выравнивание относительно контейнера.
    ///
    /// Большинство значений этого свойства не оказывают заметного влияния,
    /// когда размер контейнера совпадает с размером контента.
    public let alignment: Alignment

    /// Создает контейнер для переопределения размеров и положения компонента.
    ///
    /// - Parameters:
    ///   - content: Компонент, который будет обернут в контейнер.
    ///   - sizing: Данные для определения размеров.
    ///   - alignment: Выравнивание относительно контейнера.
    public init(
        content: Content,
        sizing: ComponentSizing,
        alignment: Alignment = .center
    ) {
        self.content = content
        self.sizing = sizing
        self.alignment = alignment
    }
}

extension ComponentFrame: Equatable where Content: Equatable { }
extension ComponentFrame: Sendable where Content: Sendable { }

extension ComponentFrame: View {

    public var body: some View {
        switch (sizing.width, sizing.height) {
        case let (.fixed(width), .fixed(height)):
            content.frame(width: width, height: height, alignment: alignment)

        case let (.fixed(width), .hug):
            content.frame(width: width, alignment: alignment)

        case let (.fixed(width), .fill):
            content
                .frame(maxHeight: .infinity, alignment: alignment)
                .frame(width: width, alignment: alignment)

        case let (.hug, .fixed(height)):
            content.frame(height: height, alignment: alignment)

        case (.hug, .hug):
            content

        case (.hug, .fill):
            content.frame(maxHeight: .infinity, alignment: alignment)

        case let (.fill, .fixed(height)):
            content
                .frame(maxWidth: .infinity, alignment: alignment)
                .frame(height: height, alignment: alignment)

        case (.fill, .hug):
            content.frame(maxWidth: .infinity, alignment: alignment)

        case (.fill, .fill):
            content.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
        }
    }
}

extension ComponentFrame: Component where Content: Equatable {

    public func sizing(fitting size: CGSize, context: ComponentContext) -> ComponentSizing {
        sizing
    }
}

extension View {

    /// Помещает UI-представление в контейнер с заданными размерами и выравниванием.
    ///
    /// - Parameters:
    ///   - sizing: Данные для определения размеров.
    ///   - alignment: Выравнивание относительно контейнера. По умолчанию равен `center`.
    /// - Returns: Контейнер для переопределения размеров и положения UI-представления.
    ///
    /// - SeeAlso: ``ComponentFrame``
    /// - SeeAlso: ``ComponentSizing``
    /// - SeeAlso: ``ComponentSizingStrategy``
    public nonisolated func frame(
        sizing: ComponentSizing,
        alignment: Alignment = .center
    ) -> ComponentFrame<Self> {
        ComponentFrame(
            content: self,
            sizing: sizing,
            alignment: alignment
        )
    }

    /// Помещает UI-представление в контейнер с заданными размерами и выравниванием.
    ///
    /// - Parameters:
    ///   - width: Стратегия определения ширины компонента. По умолчанию равен `hug`.
    ///   - height: Стратегия определения высоты компонента. По умолчанию равен `hug`.
    ///   - alignment: Выравнивание контента относительно контейнера. По умолчанию равен `center`.
    /// - Returns: Контейнер для переопределения размеров и положения UI-представления.
    ///
    /// - SeeAlso: ``ComponentFrame``
    /// - SeeAlso: ``ComponentSizing``
    /// - SeeAlso: ``ComponentSizingStrategy``
    public nonisolated func frame(
        width: ComponentSizingStrategy = .hug,
        height: ComponentSizingStrategy = .hug,
        alignment: Alignment = .center
    ) -> ComponentFrame<Self> {
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
    ///   - alignment: Выравнивание контента относительно контейнера. По умолчанию равен `center`.
    /// - Returns: Контейнер для переопределения размеров и положения UI-представления.
    ///
    /// - SeeAlso: ``ComponentFrame``
    /// - SeeAlso: ``ComponentSizing``
    /// - SeeAlso: ``ComponentSizingStrategy``
    public nonisolated func frame(
        width: CGFloat,
        height: ComponentSizingStrategy,
        alignment: Alignment = .center
    ) -> ComponentFrame<Self> {
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
    ///   - alignment: Выравнивание контента относительно контейнера. По умолчанию равен `center`.
    /// - Returns: Контейнер для переопределения размеров и положения UI-представления.
    ///
    /// - SeeAlso: ``ComponentFrame``
    /// - SeeAlso: ``ComponentSizing``
    /// - SeeAlso: ``ComponentSizingStrategy``
    public nonisolated func frame(
        width: ComponentSizingStrategy,
        height: CGFloat,
        alignment: Alignment = .center
    ) -> ComponentFrame<Self> {
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

    /// Помещает UI-представление в контейнер с заданной шириной и выравниванием,
    /// сохраняя его собственную высоту.
    ///
    /// - Parameters:
    ///   - width: Фиксированная ширина компонента.
    ///   - alignment: Выравнивание контента относительно контейнера. По умолчанию равен `center`.
    /// - Returns: Контейнер для переопределения размеров и положения UI-представления.
    ///
    /// - SeeAlso: ``ComponentFrame``
    /// - SeeAlso: ``ComponentSizing``
    /// - SeeAlso: ``ComponentSizingStrategy``
    public nonisolated func frame(
        width: CGFloat,
        alignment: Alignment = .center
    ) -> ComponentFrame<Self> {
        frame(
            sizing: ComponentSizing(
                width: width,
                height: .hug
            ),
            alignment: alignment
        )
    }

    /// Помещает UI-представление в контейнер с заданной высотой и выравниванием,
    /// сохраняя его собственную ширину.
    ///
    /// - Parameters:
    ///   - height: Фиксированная высота компонента.
    ///   - alignment: Выравнивание контента относительно контейнера. По умолчанию равен `center`.
    /// - Returns: Контейнер для переопределения размеров и положения UI-представления.
    ///
    /// - SeeAlso: ``ComponentFrame``
    /// - SeeAlso: ``ComponentSizing``
    /// - SeeAlso: ``ComponentSizingStrategy``
    public nonisolated func frame(
        height: CGFloat,
        alignment: Alignment = .center
    ) -> ComponentFrame<Self> {
        frame(
            sizing: ComponentSizing(
                width: .hug,
                height: height
            ),
            alignment: alignment
        )
    }

    /// Помещает UI-представление в контейнер с заданными размерами и выравниванием.
    ///
    /// - Parameters:
    ///   - width: Фиксированная ширина компонента.
    ///   - height: Фиксированная высота компонента.
    ///   - alignment: Выравнивание контента относительно контейнера. По умолчанию равен `center`.
    /// - Returns: Контейнер для переопределения размеров и положения UI-представления.
    ///
    ///
    /// - SeeAlso: ``ComponentFrame``
    /// - SeeAlso: ``ComponentSizing``
    /// - SeeAlso: ``ComponentSizingStrategy``
    public nonisolated func frame(
        width: CGFloat,
        height: CGFloat,
        alignment: Alignment = .center
    ) -> ComponentFrame<Self> {
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
