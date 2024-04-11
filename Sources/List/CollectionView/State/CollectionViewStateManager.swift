import UIKit

internal final class CollectionViewStateManager<Layout: ListLayout>:
    NSObject,
    UICollectionViewDataSource {

    internal private(set) var state: CollectionViewState<Layout> = .empty

    internal let collectionView: UICollectionView

    internal init(collectionView: UICollectionView) {
        self.collectionView = collectionView

        super.init()

        registerInconsistentCell()
        registerInconsistentSupplementaryView()
    }

    private func invalidateItemsLayout(at indexPaths: [IndexPath]) {
        let invalidationContext = UICollectionViewLayoutInvalidationContext()

        invalidationContext.invalidateItems(at: indexPaths)

        collectionView
            .collectionViewLayout
            .invalidateLayout(with: invalidationContext)
    }

    private func invalidateHeadersLayout(at indexPaths: [IndexPath]) {
        let invalidationContext = UICollectionViewLayoutInvalidationContext()

        invalidationContext.invalidateSupplementaryElements(
            ofKind: UICollectionView.elementKindSectionHeader,
            at: indexPaths
        )

        collectionView
            .collectionViewLayout
            .invalidateLayout(with: invalidationContext)
    }

    private func invalidateFootersLayout(at indexPaths: [IndexPath]) {
        let invalidationContext = UICollectionViewLayoutInvalidationContext()

        invalidationContext.invalidateSupplementaryElements(
            ofKind: UICollectionView.elementKindSectionFooter,
            at: indexPaths
        )

        collectionView
            .collectionViewLayout
            .invalidateLayout(with: invalidationContext)
    }

    private func itemContext(
        for item: ListSectionItem,
        at indexPath: IndexPath
    ) -> ComponentContext? {
        guard let context = state.context else {
            return nil
        }

        let itemContext = context
            .componentIdentifier(item.wrapped.identifier)
            .componentLayoutInvalidation { [weak self] in
                self?.invalidateItemsLayout(at: [indexPath])
            }

        guard let collectionViewLayout = collectionView.collectionViewLayout as? AnyCollectionViewLayout else {
            return itemContext
        }

        return itemContext.componentContainerSize(collectionViewLayout.itemContainerSize(at: indexPath))
    }

    private func headerContext(
        for section: ListSection<Layout>,
        at indexPath: IndexPath
    ) -> ComponentContext? {
        guard let context = state.context else {
            return nil
        }

        let headerContext = context
            .componentIdentifier([section.identifier, "Header"])
            .componentLayoutInvalidation { [weak self] in
                self?.invalidateHeadersLayout(at: [indexPath])
            }

        guard let collectionViewLayout = collectionView.collectionViewLayout as? AnyCollectionViewLayout else {
            return headerContext
        }

        return headerContext.componentContainerSize(collectionViewLayout.headerContainerSize(at: indexPath))
    }

    private func footerContext(
        for section: ListSection<Layout>,
        at indexPath: IndexPath
    ) -> ComponentContext? {
        guard let context = state.context else {
            return nil
        }

        let footerContext = context
            .componentIdentifier([section.identifier, "Footer"])
            .componentLayoutInvalidation { [weak self] in
                self?.invalidateFootersLayout(at: [indexPath])
            }

        guard let collectionViewLayout = collectionView.collectionViewLayout as? AnyCollectionViewLayout else {
            return footerContext
        }

        return footerContext.componentContainerSize(collectionViewLayout.footerContainerSize(at: indexPath))
    }

    private func registerInconsistentCell() {
        collectionView.register(
            CollectionViewInconsistentCell.self,
            forCellWithReuseIdentifier: CollectionViewInconsistentCell.reuseIdentifier
        )
    }

    private func registerInconsistentSupplementaryView() {
        collectionView.register(
            CollectionViewInconsistentSupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CollectionViewInconsistentSupplementaryView.reuseIdentifier
        )

        collectionView.register(
            CollectionViewInconsistentSupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: CollectionViewInconsistentSupplementaryView.reuseIdentifier
        )
    }

    private func registerCells() {
        for item in state.sections.lazy.flatMap({ $0.items }) {
            collectionView.register(
                item.cellType,
                forCellWithReuseIdentifier: item.cellType.reuseIdentifier
            )
        }
    }

    private func registerHeaderViews() {
        for header in state.sections.lazy.compactMap({ $0.header }) {
            collectionView.register(
                header.viewType,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: header.viewType.reuseIdentifier
            )
        }
    }

    private func registerFooterViews() {
        for footer in state.sections.lazy.compactMap({ $0.footer }) {
            collectionView.register(
                footer.viewType,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: footer.viewType.reuseIdentifier
            )
        }
    }

    private func dequeueCell(at indexPath: IndexPath) -> UICollectionViewCell? {
        guard let item = state.item(at: indexPath) else {
            return nil
        }

        guard let context = itemContext(for: item, at: indexPath) else {
            return nil
        }

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: item.cellType.reuseIdentifier,
            for: indexPath
        )

        item.updateCell(cell, context: context)

        return cell
    }

    private func dequeueHeaderView(at indexPath: IndexPath) -> UICollectionReusableView? {
        guard let section = state.section(at: indexPath) else {
            return nil
        }

        guard let header = section.header else {
            return nil
        }

        guard let context = headerContext(for: section, at: indexPath) else {
            return nil
        }

        let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: header.viewType.reuseIdentifier,
            for: indexPath
        )

        header.updateView(view, context: context)

        return view
    }

    private func dequeueFooterView(at indexPath: IndexPath) -> UICollectionReusableView? {
        guard let section = state.section(at: indexPath) else {
            return nil
        }

        guard let footer = section.footer else {
            return nil
        }

        guard let context = footerContext(for: section, at: indexPath) else {
            return nil
        }

        let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: footer.viewType.reuseIdentifier,
            for: indexPath
        )

        footer.updateView(view, context: context)

        return view
    }

    private func updateCell(at indexPath: IndexPath) {
        guard let item = state.item(at: indexPath) else {
            return assertionFailure("Inconsistent state of UICollectionView")
        }

        guard let context = itemContext(for: item, at: indexPath) else {
            return assertionFailure("Inconsistent state of UICollectionView")
        }

        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return assertionFailure("Inconsistent state of UICollectionView")
        }

        item.updateCell(cell, context: context)
    }

    private func updateHeaderView(at indexPath: IndexPath) {
        guard let section = state.section(at: indexPath) else {
            return assertionFailure("Inconsistent state of UICollectionView")
        }

        guard let header = section.header else {
            return assertionFailure("Inconsistent state of UICollectionView")
        }

        guard let context = headerContext(for: section, at: indexPath) else {
            return assertionFailure("Inconsistent state of UICollectionView")
        }

        let kind = UICollectionView.elementKindSectionHeader

        guard let view = collectionView.supplementaryView(forElementKind: kind, at: indexPath) else {
            return assertionFailure("Inconsistent state of UICollectionView")
        }

        header.updateView(view, context: context)
    }

    private func updateFooterView(at indexPath: IndexPath) {
        guard let section = state.section(at: indexPath) else {
            return assertionFailure("Inconsistent state of UICollectionView")
        }

        guard let footer = section.footer else {
            return assertionFailure("Inconsistent state of UICollectionView")
        }

        guard let context = footerContext(for: section, at: indexPath) else {
            return assertionFailure("Inconsistent state of UICollectionView")
        }

        let kind = UICollectionView.elementKindSectionFooter

        guard let view = collectionView.supplementaryView(forElementKind: kind, at: indexPath) else {
            return assertionFailure("Inconsistent state of UICollectionView")
        }

        footer.updateView(view, context: context)
    }

    internal func updateCells(at indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            updateCell(at: indexPath)
        }

        invalidateItemsLayout(at: indexPaths)
    }

    internal func updateHeaderViews(at indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            updateHeaderView(at: indexPath)
        }

        invalidateHeadersLayout(at: indexPaths)
    }

    internal func updateFooterViews(at indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            updateFooterView(at: indexPath)
        }

        invalidateFootersLayout(at: indexPaths)
    }

    internal func updateState(
        sections: [ListSection<Layout>],
        context: ComponentContext
    ) {
        self.state = CollectionViewState(
            sections: sections,
            context: context
        )

        registerCells()
        registerHeaderViews()
        registerFooterViews()
    }

    internal func itemContext(at indexPath: IndexPath) -> ComponentContext? {
        state.item(at: indexPath).flatMap { item in
            itemContext(for: item, at: indexPath)
        }
    }

    internal func headerContext(at indexPath: IndexPath) -> ComponentContext? {
        state.section(at: indexPath).flatMap { section in
            headerContext(for: section, at: indexPath)
        }
    }

    internal func footerContext(at indexPath: IndexPath) -> ComponentContext? {
        state.section(at: indexPath).flatMap { section in
            footerContext(for: section, at: indexPath)
        }
    }

    // MARK: - UICollectionViewDataSource

    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        state.sections.count
    }

    internal func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        state.sections[section].items.count
    }

    internal func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if let cell = dequeueCell(at: indexPath) {
            return cell
        }

        assertionFailure("Inconsistent state of UICollectionView")

        return collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionViewInconsistentCell.reuseIdentifier,
            for: indexPath
        )
    }

    internal func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if let view = dequeueHeaderView(at: indexPath) {
                return view
            }

        case UICollectionView.elementKindSectionFooter:
            if let view = dequeueFooterView(at: indexPath) {
                return view
            }

        default:
            fatalError("Unsupported kind of UICollectionView supplementary element: \(kind)")
        }

        assertionFailure("Inconsistent state of UICollectionView")

        return collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: CollectionViewInconsistentSupplementaryView.reuseIdentifier,
            for: indexPath
        )
    }
}
