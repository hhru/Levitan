import Foundation

internal struct CollectionViewLayoutScrollAnchor {

    internal let axis: CollectionViewLayoutScrollAnchorAxis

    internal var item: CollectionViewLayoutScrollAnchorItem?
    internal var offset: CGFloat

    private mutating func resetToFirstItem<Layout: ListLayout>(state: ListLayoutState<Layout>) {
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

    private mutating func resetToPreviousItem<Layout: ListLayout>(
        at newItemPath: ItemPath,
        before previousItem: CollectionViewLayoutScrollAnchorItem,
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

    internal mutating func reset() {
        item = nil
        offset = .zero
    }

    internal mutating func updateDeletingSections<Layout: ListLayout>(
        at sectionIndices: [Int],
        currentState: ListLayoutState<Layout>,
        previousState: ListLayoutState<Layout>
    ) {
        guard let previousItem = item else {
            return
        }

        var itemPath = previousItem.path

        var sectionIndices = sectionIndices.drop { sectionIndex in
            sectionIndex > itemPath.section
        }

        while let sectionIndex = sectionIndices.first {
            guard sectionIndex == itemPath.section else {
                break
            }

            guard let newItemPath = previousState.previousSectionItemPath(before: itemPath.section) else {
                return resetToFirstItem(state: currentState)
            }

            itemPath = newItemPath

            sectionIndices = sectionIndices.dropFirst()
        }

        if itemPath.section != previousItem.path.section {
            resetToPreviousItem(
                at: itemPath,
                before: previousItem,
                state: previousState
            )
        }

        itemPath.section -= sectionIndices.count

        item = CollectionViewLayoutScrollAnchorItem(
            path: itemPath,
            part: item?.part ?? previousItem.part
        )
    }

    internal mutating func updateDeletingItems<Layout: ListLayout>(
        at itemIndexPaths: [IndexPath],
        currentState: ListLayoutState<Layout>,
        previousState: ListLayoutState<Layout>
    ) {
        guard let previousItem = item else {
            return
        }

        var itemPath = previousItem.path

        var itemIndexPaths = itemIndexPaths.drop { itemIndexPath in
            itemIndexPath.section != itemPath.section || itemIndexPath.item > itemPath.index
        }

        while let itemIndexPath = itemIndexPaths.first {
            guard itemIndexPath.section == itemPath.section, itemIndexPath.item == itemPath.index else {
                break
            }

            guard let newItemPath = previousState.previousItemPath(before: itemPath) else {
                return resetToFirstItem(state: currentState)
            }

            itemPath = newItemPath

            itemIndexPaths = itemIndexPaths.drop { itemIndexPath in
                itemIndexPath.section != itemPath.section || itemIndexPath.item > itemPath.index
            }
        }

        if itemPath.section != previousItem.path.section {
            resetToPreviousItem(
                at: itemPath,
                before: previousItem,
                state: previousState
            )
        }

        itemPath.index -= itemIndexPaths.count { $0.section == itemPath.section }

        item = CollectionViewLayoutScrollAnchorItem(
            path: itemPath,
            part: item?.part ?? previousItem.part
        )
    }

    internal mutating func updateInsertingSections<Layout: ListLayout>(
        _ sections: [(key: Int, value: ListLayoutSection<Layout>)]
    ) {
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

    internal mutating func updateInsertingItems(
        _ items: [(key: IndexPath, value: ListLayoutItem)]
    ) {
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

    internal mutating func preservePosition<Layout: ListLayout>(
        _ position: CGFloat,
        itemIndexPath: IndexPath?,
        state: ListLayoutState<Layout>,
        anchor: CGFloat
    ) {
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
            let size = state.frame.map(axis.size(of:)) ?? .zero

            item = nil
            offset = position - size * anchor
        }
    }

    internal func restorePosition<Layout: ListLayout>(
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
}

extension CollectionViewLayoutScrollAnchor {

    internal static let horizontal = Self(axis: .horizontal, item: nil, offset: .zero)
    internal static let vertical = Self(axis: .vertical, item: nil, offset: .zero)
}
