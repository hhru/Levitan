#if canImport(UIKit)
import UIKit

@MainActor
internal final class CollectionViewUpdateManager<Layout: FlowLayout> {

    internal typealias Section = FlowSection<Layout>
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

    internal func update(
        strategy: FlowUpdateStrategy,
        sections: [Section],
        context: ComponentContext,
        completion: (@MainActor (_ skipped: Bool) -> Void)?
    ) {
        let update = Update(
            strategy: strategy,
            sections: sections,
            context: context,
            completion: completion
        )

        if let pendingUpdate {
            pendingUpdate.completion?(true)
        }

        pendingUpdate = update

        if currentUpdate == nil {
            performNextUpdate()
        }
    }
}

extension CollectionViewUpdateManager {

    private func performNextUpdate() {
        currentUpdate = pendingUpdate
        pendingUpdate = nil

        guard let update = currentUpdate else {
            return
        }

        performUpdate(update: update) { [weak self] in
            update.completion?(false)
            self?.performNextUpdate()
        }
    }

    private func performUpdate(
        update: Update,
        completion: @escaping @MainActor () -> Void
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

    private func reloadSections(
        with sections: [Section],
        context: ComponentContext,
        completion: @escaping @MainActor () -> Void
    ) {
        stateManager.updateState(
            sections: sections,
            context: context
        )

        collectionView.reloadData(completion: completion)
    }

    private func updateSections(
        with sections: [Section],
        context: ComponentContext,
        completion: @escaping @MainActor () -> Void
    ) {
        let changesets = differenceCalculator.calculateDifference(
            sourceSections: self.stateManager.state.sections,
            targetSections: sections
        )

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
}
#endif
