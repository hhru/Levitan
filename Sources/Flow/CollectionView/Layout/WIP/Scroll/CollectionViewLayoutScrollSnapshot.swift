#if canImport(UIKit)
import Foundation

@MainActor
internal struct CollectionViewLayoutScrollSnapshot<Layout: FlowLayout> {

    internal var horizontalAnchor: CollectionViewLayoutScrollAnchor<Layout>
    internal var verticalAnchor: CollectionViewLayoutScrollAnchor<Layout>

    internal init(
        contentBounds: CGRect,
        layout: Layout
    ) {
        horizontalAnchor = CollectionViewLayoutScrollAnchor(
            axis: .horizontal,
            position: contentBounds.minX + contentBounds.width * layout.scrollAnchor.x
        )

        verticalAnchor = CollectionViewLayoutScrollAnchor(
            axis: .vertical,
            position: contentBounds.minY + contentBounds.height * layout.scrollAnchor.y
        )
    }

    internal init(
        contentBounds: CGRect,
        visibleItems: [IndexPath: CGRect],
        state: FlowLayoutState<Layout>,
        layout: Layout
    ) {
        let horizontalPosition = contentBounds.minX + contentBounds.width * layout.scrollAnchor.x
        let verticalPosition = contentBounds.minY + contentBounds.height * layout.scrollAnchor.y

        let horizontalItemIndexPath = layout.horizontalScrollAnchorItem(
            state: state,
            contentBounds: contentBounds,
            visibleItems: visibleItems
        )

        let verticalItemIndexPath = layout.verticalScrollAnchorItem(
            state: state,
            contentBounds: contentBounds,
            visibleItems: visibleItems
        )

        horizontalAnchor = CollectionViewLayoutScrollAnchor(
            axis: .horizontal,
            position: horizontalPosition,
            anchor: layout.scrollAnchor.x,
            itemIndexPath: horizontalItemIndexPath,
            state: state
        )

        verticalAnchor = CollectionViewLayoutScrollAnchor(
            axis: .vertical,
            position: verticalPosition,
            anchor: layout.scrollAnchor.y,
            itemIndexPath: verticalItemIndexPath,
            state: state
        )
    }

    internal func restorePosition(
        state: FlowLayoutState<Layout>,
        layout: Layout,
        contentBounds: CGRect
    ) -> CGPoint {
        let horizontalPosition = horizontalAnchor.restorePosition(
            state: state,
            anchor: layout.scrollAnchor.x
        )

        let verticalPosition = verticalAnchor.restorePosition(
            state: state,
            anchor: layout.scrollAnchor.y
        )

        return CGPoint(
            x: max(horizontalPosition - contentBounds.width * layout.scrollAnchor.x, .zero),
            y: max(verticalPosition - contentBounds.height * layout.scrollAnchor.y, .zero)
        )
    }

    internal mutating func updateDeletingSections(
        at deletedSectionIndices: [Int],
        currentState: FlowLayoutState<Layout>,
        previousState: FlowLayoutState<Layout>
    ) {
        horizontalAnchor.updateDeletingSections(
            at: deletedSectionIndices,
            currentState: currentState,
            previousState: previousState
        )

        verticalAnchor.updateDeletingSections(
            at: deletedSectionIndices,
            currentState: currentState,
            previousState: previousState
        )
    }

    internal mutating func updateDeletingItems(
        at deletedItemIndexPaths: [IndexPath],
        currentState: FlowLayoutState<Layout>,
        previousState: FlowLayoutState<Layout>
    ) {
        horizontalAnchor.updateDeletingItems(
            at: deletedItemIndexPaths,
            currentState: currentState,
            previousState: previousState
        )

        verticalAnchor.updateDeletingItems(
            at: deletedItemIndexPaths,
            currentState: currentState,
            previousState: previousState
        )
    }

    internal mutating func updateInsertingSections(_ sections: [(key: Int, value: FlowLayoutSection<Layout>)]) {
        horizontalAnchor.updateInsertingSections(sections)
        verticalAnchor.updateInsertingSections(sections)
    }

    internal mutating func updateInsertingItems(_ items: [(key: IndexPath, value: FlowLayoutItem)]) {
        horizontalAnchor.updateInsertingItems(items)
        verticalAnchor.updateInsertingItems(items)
    }
}
#endif
