#if canImport(UIKit)
import Foundation

/// Модификатор токенов UI-компонента.
///
/// Кроме стандартных полей протокола `TokenViewModifier`,
/// протокол `ComponentTokenModifier` требует реализацию метода `sizing(content:fitting:context:)`,
/// сохраняя возможность встраивать компонент в Lazy-контейнер (например, коллекцию), например:
///
/// ``` swift
/// struct AccentColorModifier<Content: Component>: ComponentTokenModifier {
///
///     let color: ColorToken?
///
///     func body(content: Content, theme: TokenTheme) -> some View {
///         content.accentColor(color?.color.resolve(for: theme))
///     }
///
///     func sizing(
///         content: Content,
///         fitting size: CGSize,
///         context: ComponentContext
///     ) -> ComponentSizing {
///         // Модификатор не влияет на размеры компонента,
///         // поэтому возвращает данные контента как есть
///         content.sizing(
///             fitting: size,
///             context: context
///         )
///     }
/// }
///
/// extension Component {
///
///     public nonisolated func accentColor(_ color: ColorToken?) -> some Component {
///         modifier(AccentColorModifier(color: color))
///     }
/// }
/// ```
///
/// - SeeAlso: ``Component``
/// - SeeAlso: ``TokenViewModifier``
public protocol ComponentTokenModifier: TokenViewModifier, Equatable
where Content: Component {

    /// Возвращает данные для определения размеров компонента.
    ///
    /// Используется при встраивании любого компонента в Lazy-контейнер (например, коллекцию)
    /// или при встраивании UIKit-компонента в SwiftUI-представление.
    ///
    /// Так как большинство модификаторов не меняют размеры компонентов,
    /// реализация по умолчанию возвращает данные контента как есть.
    ///
    /// - Note: Может быть вызван многократно в рамках прохода лэйаута.
    ///
    /// - Parameters:
    ///   - content: Компонент, к которому применен модификатор.
    ///   - size: Предлагаемый размер компонента. Чаще всего является размером контейнера.
    ///   - context: Контекст компонента.
    /// - Returns: Данные для определения размеров компонента.
    ///
    /// - SeeAlso: ``ComponentSizing``
    /// - SeeAlso: ``ComponentContext``
    func sizing(
        content: Content,
        fitting size: CGSize,
        context: ComponentContext
    ) -> ComponentSizing
}

extension ComponentTokenModifier {

    public func sizing(
        content: Content,
        fitting size: CGSize,
        context: ComponentContext
    ) -> ComponentSizing {
        content.sizing(
            fitting: size,
            context: context
        )
    }
}

extension TokenModifiedView: Component where
    Modifier: ComponentTokenModifier,
    Self: Equatable {

    public func sizing(
        fitting size: CGSize,
        context: ComponentContext
    ) -> ComponentSizing {
        modifier.sizing(
            content: content,
            fitting: size,
            context: context
        )
    }
}
#endif
