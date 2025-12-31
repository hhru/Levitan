#if canImport(UIKit)
import UIKit

@MainActor
internal final class CollectionViewManager<Layout: FlowLayout> {

    internal typealias Section = FlowSection<Layout>

    private let stateManager: CollectionViewStateManager<Layout>
    private let delegateManager: CollectionViewDelegateManager<Layout>
    private let updateManager: CollectionViewUpdateManager<Layout>

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

        if #available(iOS 16.0, tvOS 16.0, *) {
            collectionView.selfSizingInvalidation = .disabled
        }
    }

    internal func sectionIndexPath(where predicate: FlowSectionPredicate<Layout>) -> IndexPath? {
        sections
            .firstIndex { predicate($0) }
            .map { IndexPath(section: $0) }
    }

    internal func nextSectionIndexPath(where predicate: FlowSectionPredicate<Layout>) -> IndexPath? {
        guard let index = sections.firstIndex(where: { predicate($0) }) else {
            return nil
        }

        return sections
            .enumerated()
            .dropFirst(index + 1)
            .first { !$0.element.items.isEmpty }
            .map { IndexPath(section: $0.offset) }
    }

    internal func itemIndexPath(where predicate: FlowItemPredicate) -> IndexPath? {
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

    internal func nextItemIndexPath(after predicate: FlowItemPredicate) -> IndexPath? {
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

        if indexPath.row < sections[indexPath.section].items.count {
            return nextIndexPath
        }

        return sections
            .enumerated()
            .dropFirst(indexPath.section + 1)
            .first { !$0.element.items.isEmpty }
            .map { IndexPath(row: .zero, section: $0.offset) }
    }

    internal func update(
        strategy: FlowUpdateStrategy,
        sections: [Section],
        context: ComponentContext,
        completion: (@MainActor (_ skipped: Bool) -> Void)? = nil
    ) {
        updateManager.update(
            strategy: strategy,
            sections: sections,
            context: context,
            completion: completion
        )
    }
}
#endif
