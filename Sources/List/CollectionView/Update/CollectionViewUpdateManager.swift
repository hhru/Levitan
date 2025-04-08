#if canImport(UIKit)
import UIKit

internal final class CollectionViewUpdateManager<Layout: ListLayout> {

    internal typealias Section = ListSection<Layout>
    internal typealias Update = CollectionViewUpdate<Layout>

    private var currentUpdate: Update?
    private var pendingUpdate: Update?

    internal let collectionView: UICollectionView
    internal let stateManager: CollectionViewStateManager<Layout>

    private let differenceCalculator = DifferenceCalculator()

    internal init(
        collectionView: UICollectionView,
        stateManager: CollectionViewStateManager<Layout>
    ) {
        self.collectionView = collectionView
        self.stateManager = stateManager
    }

    private func reloadSections(
        with sections: [Section],
        context: ComponentContext,
        completion: @escaping () -> Void
    ) {
        stateManager.updateState(
            sections: sections,
            context: context
        )

        collectionView.reloadData(completion: completion)
    }

    private func updateSections(
        with sections: [Section],
        changesets: [DifferenceChangeset<Section>],
        context: ComponentContext,
        completion: @escaping () -> Void
    ) {
        collectionView.updateData(
            using: changesets,
            updateSections: { sections in
                stateManager.updateState(
                    sections: sections,
                    context: context
                )
            },
            updateCells: { indexPaths in
                stateManager.updateCells(at: indexPaths)
            },
            completion: completion
        )
    }

    private func updateSections(
        with sections: [Section],
        context: ComponentContext,
        completion: @escaping () -> Void
    ) {
        let changesets = differenceCalculator.calculateDifference(
            sourceSections: self.stateManager.state.sections,
            targetSections: sections
        )

        updateSections(
            with: sections,
            changesets: changesets,
            context: context,
            completion: completion
        )
    }

    private func performUpdate(
        update: Update,
        completion: @escaping () -> Void
    ) {
        switch update.strategy {
        case .reload:
            reloadSections(
                with: update.sections,
                context: update.context,
                completion: completion
            )

        case .update:
            updateSections(
                with: update.sections,
                context: update.context,
                completion: completion
            )
        }
    }

    private func performNextUpdate() {
        currentUpdate = pendingUpdate
        pendingUpdate = nil

        guard let update = currentUpdate else {
            return
        }

        performUpdate(update: update) { [weak self] in
            update.completion(false)
            self?.performNextUpdate()
        }
    }

    internal func update(
        strategy: ListUpdateStrategy,
        sections: [Section],
        context: ComponentContext,
        completion: @escaping (_ skipped: Bool) -> Void
    ) {
        let update = Update(
            strategy: strategy,
            sections: sections,
            context: context,
            completion: completion
        )

        if let pendingUpdate {
            pendingUpdate.completion(true)
        }

        pendingUpdate = update

        if currentUpdate == nil {
            performNextUpdate()
        }
    }
}
#endif
