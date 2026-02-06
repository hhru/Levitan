#if canImport(UIKit)
import SwiftUI

/// Модификатор, который может быть применен к компонентам
/// для изменения их представления или поведения.
///
/// Кроме стандартных полей протокола `ViewModifier` из SwiftUI,
/// протокол `ComponentModifier` требует реализацию метода `sizing(content:fitting:context:)`,
/// сохраняя возможность встраивать компонент в Lazy-контейнер (например, коллекцию), например:
///
/// ``` swift
/// struct PressedEffectModifier: ComponentModifier {
///
///     let isPressed: Bool
///     let anchor: UnitPoint
///
///     func body(content: Content) -> some View {
///         content
///             .scaleEffect(isPressed ? 0.95 : 1.0, anchor: anchor)
///             .animation(.easeInOut(duration: 0.2), value: isPressed)
///     }
///
///     func sizing<Content: Component>(
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
///     nonisolated func pressedEffect(
///         _ isPressed: Bool,
///         anchor: UnitPoint = .center
///     ) -> some Component {
///         modifier(
///             PressedEffectModifier(
///                 isPressed: isPressed,
///                 anchor: anchor
///             )
///         )
///     }
/// }
/// ```
///
/// - SeeAlso: ``Component``
public protocol ComponentModifier: ViewModifier, Equatable {

    /// Возвращает данные для определения размеров компонента.
    ///
    /// Используется при встраивании любого компонента в Lazy-контейнер (например, коллекцию)
    /// или при встраивании UIKit-компонента в SwiftUI-представление.
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
    func sizing<Content: Component>(
        content: Content,
        fitting size: CGSize,
        context: ComponentContext
    ) -> ComponentSizing
}

extension ModifiedContent: Component where
    Content: Component,
    Modifier: ComponentModifier {

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
