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
public struct AnyComponent {

    /// UIKit-представление компонента для использования в UIKit-контейнере.
    ///
    /// Для отображения компонента со стертым типом в UIKit тип его UI-представления так же стирается,
    /// используя `AnyComponentView`.
    ///
    /// - SeeAlso: ``AnyComponentView``
    public typealias UIView = AnyComponentView

    private let wrapped: any Component

    /// Создает обертку со стертым типом компонента.
    ///
    /// - Parameter wrapped: Оборачиваемый компонент.
    public init<Wrapped: Component>(_ wrapped: Wrapped) {
        self.wrapped = wrapped
    }
}

extension AnyComponent {

    @MainActor
    internal var presenter: AnyComponentPresenter {
        wrapped.eraseToAnyComponentPresenter()
    }
}

extension AnyComponent: Component {

    public var body: AnyView {
        wrapped.eraseToAnyView()
    }

    public func sizing(
        fitting size: CGSize,
        context: ComponentContext
    ) -> ComponentSizing {
        wrapped.sizing(
            fitting: size,
            context: context
        )
    }
}

extension AnyComponent: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        if lhs.wrapped.isEqual(to: rhs.wrapped) {
            return true
        }

        if let lhs = lhs.wrapped as? Self {
            return lhs == rhs
        }

        if let rhs = rhs.wrapped as? Self {
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
    public nonisolated func eraseToAnyComponent() -> AnyComponent {
        if let component = self as? AnyComponent {
            return component
        }

        return AnyComponent(self)
    }
}
#endif
