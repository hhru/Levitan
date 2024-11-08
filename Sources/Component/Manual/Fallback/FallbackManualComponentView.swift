import UIKit

/// Частный случай `FallbackComponentView` для реализации UI-представления UIKit-компонентов.
///
/// Расширяет базовый протокол `ComponentView` требованием метода `size(for:fitting:context:)`,
/// который используется для определения фиксированных размеров компонента.
///
/// - SeeAlso: ``FallbackManualComponent``
/// - SeeAlso: ``FallbackComponent``
/// - SeeAlso: ``FallbackComponentView``
public protocol FallbackManualComponentView: FallbackComponentView {

    static func size(
        for content: Content,
        fitting size: CGSize,
        context: ComponentContext
    ) -> CGSize
}

extension FallbackManualComponentView {

    public static func sizing(
        for content: Content,
        fitting size: CGSize,
        context: ComponentContext
    ) -> ComponentSizing {
        let size = Self.size(
            for: content,
            fitting: size,
            context: context
        )

        return ComponentSizing(
            width: .fixed(size.width),
            height: .fixed(size.height)
        )
    }
}
