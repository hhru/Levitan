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
public struct AnyManualComponent: ManualComponent {

    public typealias UIView = AnyManualComponentView

    public let wrapped: AnyComponent
    public let sizeBox: (CGSize, ComponentContext) -> CGSize

    public var body: some View {
        wrapped.body
    }

    public init<Wrapped: ManualComponent>(_ wrapped: Wrapped) {
        self.wrapped = wrapped.eraseToAnyComponent()

        sizeBox = { size, context in
            wrapped.size(
                fitting: size,
                context: context
            )
        }
    }

    public func size(
        fitting size: CGSize,
        context: ComponentContext
    ) -> CGSize {
        sizeBox(size, context)
    }

    public func sizing(
        fitting size: CGSize,
        context: ComponentContext
    ) -> ComponentSizing {
        let size = sizeBox(size, context)

        return ComponentSizing(
            width: .fixed(size.width),
            height: .fixed(size.height)
        )
    }
}

extension AnyManualComponent: Equatable {

    public nonisolated static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.wrapped == rhs.wrapped
    }
}

extension ManualComponent {

    public func eraseToAnyManualComponent() -> AnyManualComponent {
        if let component = self as? AnyManualComponent {
            return component
        }

        return AnyManualComponent(self)
    }
}
#endif
