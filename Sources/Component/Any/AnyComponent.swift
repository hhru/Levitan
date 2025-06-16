#if canImport(UIKit)
import SwiftUI

/// Компонент-обертка, который стирает тип оборачиваемого компонента.
///
/// `AnyComponent` позволяет динамически изменять тип компонента по месту использования, например:
///
/// ``` swift
/// private var content: AnyComponent {
///     if someFlag {
///         Foo(text: "qwe").eraseToAnyComponent()
///     } else {
///         Bar(number: 123).eraseToAnyComponent()
///     }
/// }
/// ```
///
/// Является аналогом `AnyView` в SwiftUI и так же уничтожает иерархию при изменении типа компонента,
/// что может негативно сказаться на производительности, как в SwiftUI, так и в UIKit.
///
/// - Warning: Стирание типа компонента следует использовать с осторожностью и не применять в случаях,
///            когда тип компонента постоянно меняется.
///
/// - SeeAlso: ``Component``
/// - SeeAlso: ``AnyComponentView``
public struct AnyComponent: Component {

    /// UIKit-представление компонента для использования в UIKit-контейнере.
    ///
    /// Для отображения компонента со стертым типом в UIKit тип его UI-представления так же стирается,
    /// используя `AnyComponentView`.
    ///
    /// - SeeAlso: ``AnyComponentView``
    public typealias UIView = AnyComponentView

    /// SwiftUI-представление компонента.
    ///
    /// Для отображения компонента со стертым типом в SwiftUI его тип так же стирается,
    /// используя `AnyView`.
    public let body: AnyView

    internal let content: AnyComponentContent
    internal let presenter: AnyComponentPresenter

    private init(
        wrapped: any Component,
        body: AnyView,
        presenter: AnyComponentPresenter
    ) {
        self.content = AnyComponentContent(wrapped: wrapped)
        self.body = body
        self.presenter = presenter
    }

    /// Создает обертку со стертым типом компонента.
    ///
    /// - Parameter wrapped: Оборачиваемый компонент.
    public init<Wrapped: Component>(_ wrapped: Wrapped) {
        self.init(
            wrapped: wrapped,
            body: AnyView(wrapped),
            presenter: AnyComponentPresenter(content: wrapped)
        )
    }

    public func sizing(
        fitting size: CGSize,
        context: ComponentContext
    ) -> ComponentSizing {
        content.wrapped.sizing(
            fitting: size,
            context: context
        )
    }
}

extension AnyComponent: Equatable {

    public nonisolated static func == (lhs: Self, rhs: Self) -> Bool {
        if lhs.content.wrapped.isEqual(to: rhs.content.wrapped) {
            return true
        }

        if let lhs = lhs.content.wrapped as? AnyComponent {
            return lhs == rhs
        }

        if let rhs = rhs.content.wrapped as? AnyComponent {
            return lhs == rhs
        }

        return false
    }
}

extension Component {

    /// Оборачивает компонент в обертку со стертым типом.
    ///
    /// - Returns: Обертка со стертым типом компонента.
    ///
    /// - SeeAlso: `AnyComponent`
    public func eraseToAnyComponent() -> AnyComponent {
        if let component = self as? AnyComponent {
            return component
        }

        return AnyComponent(self)
    }
}
#endif
