#if canImport(UIKit)
import UIKit

internal struct FlowSectionItem: Sendable {

    internal let wrapped: any FlowItem
    internal let cellType: AnyFlowCell.Type

    internal let id: ComponentID

    private let updateCellBox: @Sendable @MainActor (
        _ cell: UICollectionViewCell,
        _ context: ComponentContext
    ) -> Void

    private let sizingBox: @Sendable @MainActor (
        _ size: CGSize,
        _ context: ComponentContext
    ) -> ComponentSizing

    private let isContentEqualBox: @Sendable (_ other: Self) -> Bool

    internal init<Wrapped: FlowItem>(_ wrapped: Wrapped) {
        self.wrapped = wrapped

        cellType = Wrapped.Cell.self

        id = wrapped
            .id
            .traits(ObjectIdentifier(Wrapped.self))

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

extension FlowSectionItem: Diffable {

    internal var differenceID: AnyHashable {
        id
    }

    internal func isContentEqual(to other: Self) -> Bool {
        isContentEqualBox(other)
    }
}

extension FlowSectionItem: Equatable {

    internal static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.isContentEqualBox(rhs)
    }
}

extension FlowItem {

    internal func sectionItem() -> FlowSectionItem {
        FlowSectionItem(self)
    }
}
#endif
