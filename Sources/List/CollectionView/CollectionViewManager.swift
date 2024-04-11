import UIKit

internal final class CollectionViewManager<Layout: ListLayout> {

    internal typealias Section = ListSection<Layout>

    private var stateManager: CollectionViewStateManager<Layout>
    private var delegateManager: CollectionViewDelegateManager<Layout>
    private var updateManager: CollectionViewUpdateManager<Layout>

    internal let collectionView: UICollectionView

    internal var collectionViewDelegate: UICollectionViewDelegate? {
        get { delegateManager.collectionViewDelegate }
        set { delegateManager.collectionViewDelegate = newValue }
    }

    internal var sections: [Section] {
        stateManager.state.sections
    }

    internal init(
        collectionView: UICollectionView,
        collectionViewDelegate: UICollectionViewDelegate? = nil
    ) {
        self.collectionView = collectionView

        stateManager = CollectionViewStateManager(collectionView: collectionView)

        delegateManager = CollectionViewDelegateManager(
            collectionViewDelegate: collectionViewDelegate,
            stateManager: stateManager
        )

        updateManager = CollectionViewUpdateManager(
            collectionView: collectionView,
            stateManager: stateManager
        )

        collectionView.delegate = delegateManager
        collectionView.dataSource = stateManager

        if #available(iOS 16.0, *) {
            collectionView.selfSizingInvalidation = .disabled
        }
    }

    internal func sectionIndexPath(where predicate: ListSectionPredicate<Layout>) -> IndexPath? {
        sections
            .firstIndex { predicate($0) }
            .map { IndexPath(section: $0) }
    }

    internal func itemIndexPath(where predicate: ListItemPredicate) -> IndexPath? {
        sections
            .lazy
            .enumerated()
            .compactMap { index, section in
                section
                    .items
                    .firstIndex { predicate($0.wrapped) }
                    .map { IndexPath(row: $0, section: index) }
            }
            .first
    }

    internal func nextItemIndexPath(after predicate: ListItemPredicate) -> IndexPath? {
        let indexPath = sections
            .lazy
            .enumerated()
            .compactMap { index, section in
                section
                    .items
                    .firstIndex { predicate($0.wrapped) }
                    .map { IndexPath(row: $0, section: index) }
            }
            .first

        guard let indexPath else {
            return nil
        }

        let nextIndexPath = IndexPath(
            row: indexPath.row + 1,
            section: indexPath.section
        )

        if nextIndexPath.row < sections[indexPath.section].items.count {
            return nextIndexPath
        }

        return sections
            .dropFirst(indexPath.section + 1)
            .enumerated()
            .first { !$0.element.items.isEmpty }
            .map { IndexPath(row: .zero, section: $0.offset) }
    }

    internal func update(
        strategy: ListUpdateStrategy,
        sections: [Section],
        context: ComponentContext,
        completion: ((_ skipped: Bool) -> Void)? = nil
    ) {
        updateManager.update(
            strategy: strategy,
            sections: sections,
            context: context
        ) { completion?($0) }
    }
}
