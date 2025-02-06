#if canImport(UIKit)
import SwiftUI

// TODO: Дополнить документацию

/// Модификатор, который может быть применен к UI-компонентам для изменения их представления или поведения.
///
/// Позволяет реализовать переиспользуемые сущности для модификации любых SwiftUI-представлений,
/// даже если они не соответствуют протоколу `Component`.
///
/// Кроме стандартных полей протокола `ViewModifier` из SwiftUI,
/// протокол `ComponentModifier` требует реализацию метода `sizing(content:fitting:context:)`,
/// сохраняя возможность встраивать компонент в Lazy-контейнер (например, коллекцию).
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
