#if canImport(UIKit)
import CoreGraphics
import Foundation

internal struct CollectionViewLayoutScrollAnchor<Layout: ListLayout> {

    internal let axis: CollectionViewLayoutScrollAnchorAxis

    internal var item: CollectionViewLayoutScrollAnchorItem?
    internal var offset: CGFloat

    internal init(
        axis: CollectionViewLayoutScrollAnchorAxis,
        position: CGFloat
    ) {
        self.axis = axis
        self.item = nil
        self.offset = position
    }

    internal init(
        axis: CollectionViewLayoutScrollAnchorAxis,
        position: CGFloat,
        anchor: CGFloat,
        itemIndexPath: IndexPath?,
        state: ListLayoutState<Layout>
    ) {
        self.axis = axis

        if let itemPath = itemIndexPath.map(ItemPath.init(indexPath:)) {
            let itemFrame = state
                .sections[itemPath.section]
                .items[itemPath.index]
                .frame ?? .zero

            let itemOrigin = axis.origin(of: itemFrame)
            let itemSize = axis.size(of: itemFrame)

            let itemPart = itemSize > .leastNonzeroMagnitude
                ? min(max((position - itemOrigin) / itemSize, .zero), 1.0)
                : 1.0

            item = CollectionViewLayoutScrollAnchorItem(
                path: itemPath,
                part: itemPart
            )

            offset = position - itemOrigin - itemSize * itemPart
        } else {
            let contentSize = state.frame.map(axis.size(of:)) ?? .zero

            item = nil
            offset = position - contentSize * anchor
        }
    }

    internal func restorePosition(
        state: ListLayoutState<Layout>,
        anchor: CGFloat
    ) -> CGFloat {
        guard let contentFrame = state.frame else {
            return .zero
        }

        let contentSize = axis.size(of: contentFrame)

        guard let item else {
            return min(offset + contentSize * anchor, contentSize)
        }

        let itemFrame = state
            .sections[item.path.section]
            .items[item.path.index]
            .frame ?? .zero

        let position = offset
            + axis.origin(of: itemFrame)
            + axis.size(of: itemFrame) * item.part

        return min(position, contentSize)
    }

    internal mutating func updateDeletingSections(
        at deletedSectionIndices: [Int],
        currentState: ListLayoutState<Layout>,
        previousState: ListLayoutState<Layout>
    ) {
        guard let previousItem = item else {
            return
        }

        var itemPath = previousItem.path

        var deletedSectionIndices = deletedSectionIndices.drop { deletedSectionIndex in
            deletedSectionIndex > itemPath.section
        }

        while let deletedSectionIndex = deletedSectionIndices.first {
            guard deletedSectionIndex == itemPath.section else {
                break
            }

            guard let newItemPath = previousState.previousSectionItemPath(before: itemPath.section) else {
                return resetToFirstItem(state: currentState)
            }

            itemPath = newItemPath

            deletedSectionIndices = deletedSectionIndices.dropFirst()
        }

        if itemPath.section < previousItem.path.section {
            resetToPreviousItem(
                at: itemPath,
                state: previousState
            )
        }

        itemPath.section -= deletedSectionIndices.count

        item = CollectionViewLayoutScrollAnchorItem(
            path: itemPath,
            part: item?.part ?? previousItem.part
        )
    }

    internal mutating func updateDeletingItems(
        at deletedItemIndexPaths: [IndexPath],
        currentState: ListLayoutState<Layout>,
        previousState: ListLayoutState<Layout>
    ) {
        guard let previousItem = item else {
            return
        }

        var itemPath = previousItem.path

        var deletedItemIndexPaths = deletedItemIndexPaths.drop { deletedItemIndexPath in
            deletedItemIndexPath.section != itemPath.section || deletedItemIndexPath.item > itemPath.index
        }

        while let deletedItemIndexPath = deletedItemIndexPaths.first {
            guard deletedItemIndexPath.section == itemPath.section else {
                break
            }

            guard deletedItemIndexPath.item == itemPath.index else {
                break
            }

            guard let newItemPath = previousState.previousItemPath(before: itemPath) else {
                return resetToFirstItem(state: currentState)
            }

            itemPath = newItemPath

            deletedItemIndexPaths = deletedItemIndexPaths.drop { deletedItemIndexPath in
                deletedItemIndexPath.section != itemPath.section || deletedItemIndexPath.item > itemPath.index
            }
        }

        if itemPath.section < previousItem.path.section {
            resetToPreviousItem(
                at: itemPath,
                state: previousState
            )
        }

        itemPath.index -= deletedItemIndexPaths.count { deletedItemIndexPath in
            deletedItemIndexPath.section == itemPath.section
        }

        item = CollectionViewLayoutScrollAnchorItem(
            path: itemPath,
            part: item?.part ?? previousItem.part
        )
    }

    internal mutating func updateInsertingSections(_ sections: [(key: Int, value: ListLayoutSection<Layout>)]) {
        guard let previousItem = item else {
            return
        }

        var itemPath = previousItem.path

        for (index, section) in sections {
            guard index <= itemPath.section else {
                break
            }

            let shouldAnchorToNewSection = !section.items.isEmpty
                && itemPath.section == index
                && itemPath.index == .zero
                && offset < .zero

            guard !shouldAnchorToNewSection else {
                break
            }

            itemPath.section += 1
        }

        item = CollectionViewLayoutScrollAnchorItem(
            path: itemPath,
            part: previousItem.part
        )
    }

    internal mutating func updateInsertingItems(_ items: [(key: IndexPath, value: ListLayoutItem)]) {
        guard let previousItem = item else {
            return
        }

        var itemPath = previousItem.path

        for (indexPath, _) in items {
            guard indexPath.section <= itemPath.section else {
                break
            }

            guard indexPath.section == itemPath.section else {
                continue
            }

            guard indexPath.item <= itemPath.index else {
                break
            }

            guard indexPath.item != itemPath.index || offset >= .zero else {
                break
            }

            itemPath.index += 1
        }

        item = CollectionViewLayoutScrollAnchorItem(
            path: itemPath,
            part: previousItem.part
        )
    }
}

extension CollectionViewLayoutScrollAnchor {

    private mutating func reset() {
        item = nil
        offset = .zero
    }

    private mutating func resetToFirstItem(state: ListLayoutState<Layout>) {
        let itemPath = state
            .sections
            .indices
            .first { !state.sections[$0].items.isEmpty }
            .map { ItemPath(index: .zero, section: $0) }

        guard let itemPath else {
            return reset()
        }

        item = CollectionViewLayoutScrollAnchorItem(
            path: itemPath,
            part: .zero
        )

        offset = .zero
    }

    private mutating func resetToPreviousItem(
        at newItemPath: ItemPath,
        state: ListLayoutState<Layout>
    ) {
        guard let previousItem = item else {
            return
        }

        let previousItemFrame = state
            .sections[previousItem.path.section]
            .items[previousItem.path.index]
            .frame ?? .zero

        let previousPosition = offset
            + axis.origin(of: previousItemFrame)
            + axis.size(of: previousItemFrame) * previousItem.part

        let newSection = state.sections[newItemPath.section]

        let newItemFrame = newSection.items[newItemPath.index].frame ?? .zero
        let newItemOrigin = axis.origin(of: newItemFrame)
        let newItemSize = axis.size(of: newItemFrame)

        let newPosition: CGFloat

        if offset >= .zero {
            if let newSectionFrame = newSection.frame, previousItem.path.section != newItemPath.section {
                let newSectionOrigin = axis.origin(of: newSectionFrame)
                let newSectionSize = axis.size(of: newSectionFrame)

                newPosition = min(previousPosition, newSectionOrigin + newSectionSize)
            } else {
                newPosition = min(previousPosition, newItemOrigin + newItemSize + offset)
            }
        } else {
            newPosition = previousPosition
        }

        let newItemPart = newItemSize > .leastNonzeroMagnitude
            ? min(max((newPosition - newItemOrigin) / newItemSize, .zero), 1.0)
            : 1.0

        item = CollectionViewLayoutScrollAnchorItem(
            path: newItemPath,
            part: newItemPart
        )

        offset = newPosition - newItemOrigin - newItemSize * newItemPart
    }
}
#endif
