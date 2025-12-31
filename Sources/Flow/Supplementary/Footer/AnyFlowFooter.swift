#if canImport(UIKit)
import UIKit

public struct AnyFlowFooter {

    internal let wrapped: any FlowFooter
    internal let viewType: AnyFlowFooterView.Type

    private let updateViewBox: @MainActor (
        _ view: UICollectionReusableView,
        _ context: ComponentContext
    ) -> Void

    private let sizingBox: @MainActor (
        _ size: CGSize,
        _ context: ComponentContext
    ) -> ComponentSizing

    private let isEqualBox: @Sendable (_ other: Self) -> Bool

    public init<Wrapped: FlowFooter>(_ wrapped: Wrapped) {
        nonisolated(unsafe) let wrapped = wrapped

        self.wrapped = wrapped

        viewType = Wrapped.View.self

        updateViewBox = { view, context in
            if let view = view as? Wrapped.View {
                view.update(
                    with: wrapped,
                    context: context
                )
            }
        }

        sizingBox = { size, context in
            Wrapped.View.sizing(
                for: wrapped,
                fitting: size,
                context: context
            )
        }

        isEqualBox = { other in
            wrapped == other.wrapped as? Wrapped
        }
    }

    @MainActor
    internal func updateView(
        _ view: UICollectionReusableView,
        context: ComponentContext
    ) {
        updateViewBox(view, context)
    }

    @MainActor
    internal func sizing(
        fitting size: CGSize,
        context: ComponentContext
    ) -> ComponentSizing {
        sizingBox(size, context)
    }
}

extension AnyFlowFooter: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.isEqualBox(rhs)
    }
}

extension FlowFooter {

    public func eraseToAnyFooter() -> AnyFlowFooter {
        AnyFlowFooter(self)
    }
}
#endif
