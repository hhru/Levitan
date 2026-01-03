import Foundation

public protocol ComponentTokenModifier: TokenViewModifier where Content: Component {

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
