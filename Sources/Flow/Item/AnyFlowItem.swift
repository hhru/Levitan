#if canImport(UIKit)
import UIKit

public struct AnyFlowItem: Diffable {

    internal let wrapped: any FlowItem
    internal let cellType: AnyFlowCell.Type
    internal let differenceIdentifier: AnyHashable

    private let updateCellBox: @MainActor(
        _ cell: UICollectionViewCell,
        _ context: ComponentContext
    ) -> Void

    private let sizingBox: @MainActor (
        _ size: CGSize,
        _ context: ComponentContext
    ) -> ComponentSizing

    private let isContentEqualBox: (_ other: Self) -> Bool

    public init<Wrapped: FlowItem>(_ wrapped: Wrapped) {
        nonisolated(unsafe) let wrapped = wrapped

        self.wrapped = wrapped

        cellType = Wrapped.Cell.self

        differenceIdentifier = [
            ObjectIdentifier(Wrapped.self),
            wrapped.identifier
        ]

        updateCellBox = { cell, context in
            if let cell = cell as? Wrapped.Cell {
                cell.update(
                    with: wrapped,
                    context: context
                )
            }
        }

        sizingBox = { size, context in
            Wrapped.Cell.sizing(
                for: wrapped,
                fitting: size,
                context: context
            )
        }

        isContentEqualBox = { other in
            wrapped == other.wrapped as? Wrapped
        }
    }

    internal func isContentEqual(to other: Self) -> Bool {
        isContentEqualBox(other)
    }

    @MainActor
    internal func updateCell(
        _ cell: UICollectionViewCell,
        context: ComponentContext
    ) {
        updateCellBox(cell, context)
    }

    @MainActor
    internal func sizing(
        fitting size: CGSize,
        context: ComponentContext
    ) -> ComponentSizing {
        sizingBox(size, context)
    }
}

extension AnyFlowItem: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.isContentEqualBox(rhs)
    }
}

extension FlowItem {

    public func eraseToAnyItem() -> AnyFlowItem {
        AnyFlowItem(self)
    }
}
#endif
