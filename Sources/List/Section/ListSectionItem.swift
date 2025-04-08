#if canImport(UIKit)
import UIKit

public struct ListSectionItem: Diffable {

    public let wrapped: AnyListItem

    internal let differenceIdentifier: AnyHashable
    internal let cellType: AnyListCell.Type

    private let updateCellBox: (
        _ cell: UICollectionViewCell,
        _ context: ComponentContext
    ) -> Void

    private let sizingBox: (
        _ size: CGSize,
        _ context: ComponentContext
    ) -> ComponentSizing

    private let isContentEqualBox: (_ other: Self) -> Bool

    public init<Wrapped: ListItem>(wrapped: Wrapped) {
        self.wrapped = wrapped

        differenceIdentifier = [wrapped.identifier, "\(Wrapped.self)"]
        cellType = Wrapped.Cell.self

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

    internal func updateCell(
        _ cell: UICollectionViewCell,
        context: ComponentContext
    ) {
        updateCellBox(cell, context)
    }

    internal func sizing(
        fitting size: CGSize,
        context: ComponentContext
    ) -> ComponentSizing {
        sizingBox(size, context)
    }
}

extension ListSectionItem: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.isContentEqualBox(rhs)
    }
}
#endif
