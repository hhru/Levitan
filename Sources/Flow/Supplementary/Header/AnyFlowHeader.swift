#if canImport(UIKit)
import UIKit

public struct AnyFlowHeader: Sendable {

    internal let wrapped: any FlowHeader
    internal let viewType: AnyFlowHeaderView.Type

    private let updateViewBox: @Sendable @MainActor (
        _ view: UICollectionReusableView,
        _ context: ComponentContext
    ) -> Void

    private let sizingBox: @Sendable @MainActor (
        _ size: CGSize,
        _ context: ComponentContext
    ) -> ComponentSizing

    private let isEqualBox: @Sendable (_ other: Self) -> Bool

    public init<Wrapped: FlowHeader>(_ wrapped: Wrapped) {
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

extension AnyFlowHeader: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.isEqualBox(rhs)
    }
}

extension FlowHeader {

    public func eraseToAnyHeader() -> AnyFlowHeader {
        AnyFlowHeader(self)
    }
}
#endif
