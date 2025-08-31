#if canImport(UIKit)
import SwiftUI

/// Компонент-обертка, по аналогии с `AnyComponent`, который стирает тип оборачиваемого компонента
/// c фиксированным размером.
///
/// `AnyManualComponent` позволяет динамически изменять тип компонента по месту использования, например:
///
/// ``` swift
/// private var content: AnyManualComponent {
///     if someFlag {
///         Foo(text: "qwe").eraseToAnyManualComponent()
///     } else {
///         Bar(number: 123).eraseToAnyManualComponent()
///     }
/// }
/// ```
///
/// - SeeAlso: ``ManualComponent``
/// - SeeAlso: ``AnyComponentView``
public struct AnyManualComponent {

    private let wrapped: any ManualComponent

    /// Создает обертку со стертым типом компонента.
    ///
    /// - Parameter wrapped: Оборачиваемый компонент.
    public init<Wrapped: ManualComponent>(_ wrapped: Wrapped) {
        self.wrapped = wrapped
    }
}

extension AnyManualComponent {

    @MainActor
    internal var content: AnyComponent {
        wrapped.eraseToAnyComponent()
    }
}

extension AnyManualComponent: ManualComponent {

    public typealias UIView = AnyManualComponentView

    public var body: some View {
        wrapped.eraseToAnyView()
    }

    public func size(
        fitting size: CGSize,
        context: ComponentContext
    ) -> CGSize {
        wrapped.size(
            fitting: size,
            context: context
        )
    }

    public func sizing(
        fitting size: CGSize,
        context: ComponentContext
    ) -> ComponentSizing {
        let size = wrapped.size(
            fitting: size,
            context: context
        )

        return ComponentSizing(
            width: .fixed(size.width),
            height: .fixed(size.height)
        )
    }
}

extension AnyManualComponent: Equatable {

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

extension ManualComponent {

    public nonisolated func eraseToAnyManualComponent() -> AnyManualComponent {
        if let component = self as? AnyManualComponent {
            return component
        }

        return AnyManualComponent(self)
    }
}
#endif
