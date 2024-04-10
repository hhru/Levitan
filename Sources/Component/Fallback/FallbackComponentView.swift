import SwiftUI

/// Общий протокол для реализации UI-представления UIKit-компонентов.
///
/// Расширяет базовый протокол `ComponentView` требованием метода `sizing(for:fitting:context:)`,
/// который используется для определения размеров компонента.
///
/// - SeeAlso: ``FallbackComponent``
/// - SeeAlso: ``Component``
/// - SeeAlso: ``ComponentView``
public protocol FallbackComponentView: ComponentView {

    /// Возвращает данные для определения размеров компонента.
    ///
    /// Используется при встраивании любого компонента в Lazy-контейнер (например, коллекцию)
    /// или при встраивании UIKit-компонента в SwiftUI-представление.
    ///
    /// - Note: Может быть вызван многократно в рамках прохода лэйаута.
    ///
    /// - Parameters:
    ///   - content: Данные компонента.
    ///   - size: Предлагаемый размер компонента. Чаще всего является размером контейнера.
    ///   - context: Контекст компонента.
    /// - Returns: Данные для определения размеров компонента.
    ///
    /// - SeeAlso: ``ComponentSizing``
    /// - SeeAlso: ``ComponentContext``
    static func sizing(
        for content: Content,
        fitting size: CGSize,
        context: ComponentContext
    ) -> ComponentSizing
}
