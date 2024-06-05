import SwiftUI
import UIKit

/// Общий протокол для UIKit-представлений любого компонента.
///
/// - SeeAlso: ``Component``
public protocol ComponentView: UIView {

    /// Тип контента UI-представления.
    associatedtype Content

    /// Обновляет UI-представление с заданным контентом, используя контекст при необходмости.
    ///
    /// - Parameters:
    ///   - content: Контент UI-представления.
    ///   - context: Контекст компонента.
    ///
    /// - SeeAlso: ``Component``
    /// - SeeAlso: ``ComponentContext`
    func update(
        with content: Content,
        context: ComponentContext
    )
}

extension ComponentView {

    public init(
        content: Content,
        context: ComponentContext,
        frame: CGRect = .zero
    ) {
        self.init(frame: frame)

        update(
            with: content,
            context: context
        )
    }
}
