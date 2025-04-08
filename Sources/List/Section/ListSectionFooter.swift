#if canImport(UIKit)
import UIKit

public struct ListSectionFooter {

    public let wrapped: AnyListFooter

    internal let viewType: AnyListFooterView.Type

    private let updateViewBox: (
        _ view: UICollectionReusableView,
        _ context: ComponentContext
    ) -> Void

    private let sizingBox: (
        _ size: CGSize,
        _ context: ComponentContext
    ) -> ComponentSizing

    private let isEqualBox: (_ other: Self) -> Bool

    public init<Wrapped: ListFooter>(wrapped: Wrapped) {
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

    internal func updateView(
        _ view: UICollectionReusableView,
        context: ComponentContext
    ) {
        updateViewBox(view, context)
    }

    internal func sizing(
        fitting size: CGSize,
        context: ComponentContext
    ) -> ComponentSizing {
        sizingBox(size, context)
    }
}

extension ListSectionFooter: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.isEqualBox(rhs)
    }
}
#endif
