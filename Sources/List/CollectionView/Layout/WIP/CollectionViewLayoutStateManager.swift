#if canImport(UIKit)
import UIKit

internal final class CollectionViewLayoutStateManager<Layout: ListLayout> {

    internal private(set) var currentState: ListLayoutState<Layout>?
    internal private(set) var previousState: ListLayoutState<Layout>?

    internal private(set) var contentSize: CGSize = .zero
    internal private(set) var hasPinnedElements = false

    internal weak var collectionView: UICollectionView?

    internal let updateManager: CollectionViewLayoutUpdateManager<Layout>

    private var itemAnimatedAttributes: [IndexPath: CollectionViewLayoutAttributes] = [:]
    private var headerAnimatedAttributes: [IndexPath: CollectionViewLayoutAttributes] = [:]
    private var footerAnimatedAttributes: [IndexPath: CollectionViewLayoutAttributes] = [:]

    private var delegate: CollectionViewLayoutDelegate? {
        collectionView?.delegate as? CollectionViewLayoutDelegate
    }

    internal init(updateManager: CollectionViewLayoutUpdateManager<Layout>) {
        self.updateManager = updateManager
    }

    private func sectionCurrentIndex(at index: Int) -> Int? {
        currentState?.sections.firstIndex { $0.index == index }
    }

    private func itemCurrentIndexPath(at indexPath: IndexPath) -> IndexPath? {
        guard let sections = currentState?.sections else {
            return nil
        }

        for sectionIndex in sections.indices {
            let indexPath = sections[sectionIndex]
                .items
                .firstIndex { $0.indexPath == indexPath }
                .map { IndexPath(item: $0, section: sectionIndex) }

            if let indexPath {
                return indexPath
            }
        }

        return nil
    }

    private func makeCurrentState() -> ListLayoutState<Layout> {
        guard let collectionView else {
            return ListLayoutState(sections: [])
        }

        let collectionViewLayout = collectionView.collectionViewLayout

        let sections = (0..<collectionView.numberOfSections).map { index in
            let itemCount = collectionView.numberOfItems(inSection: index)

            let items = Array(
                repeating: ListLayoutItem(),
                count: itemCount
            )

            let header = delegate?.collectionViewLayout(collectionViewLayout, hasHeaderAt: index) == true
                ? ListLayoutHeader()
                : nil

            let footer = delegate?.collectionViewLayout(collectionViewLayout, hasFooterAt: index) == true
                ? ListLayoutFooter()
                : nil

            let metrics = delegate?
                .collectionViewLayout(collectionViewLayout, metricsForSectionAt: index)
                .flatMap { $0 as? Layout.Metrics }

            return ListLayoutSection<Layout>(
                items: items,
                header: header,
                footer: footer,
                metrics: metrics
            )
        }

        return ListLayoutState(sections: sections)
    }

    private func updateCurrentState(
        invalidating: Bool = true,
        using body: (inout ListLayoutState<Layout>) -> Void
    ) {
        var state = currentState ?? makeCurrentState()

        body(&state)

        if invalidating {
            state.origin = nil
            state.size = nil
        }

        currentState = state
    }

    private func updatePreviousState(
        invalidating: Bool = true,
        using body: (inout ListLayoutState<Layout>) -> Void
    ) {
        guard var state = previousState else {
            return
        }

        body(&state)

        if invalidating {
            state.origin = nil
            state.size = nil
        }

        previousState = state
    }

    private func resetAnimatedAttributes() {
        itemAnimatedAttributes.removeAll(keepingCapacity: true)
        headerAnimatedAttributes.removeAll(keepingCapacity: true)
        footerAnimatedAttributes.removeAll(keepingCapacity: true)
    }
}

extension CollectionViewLayoutStateManager {

    // MARK: - Attributes

    internal func itemAttributes(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        currentState?
            .item(at: indexPath)?
            .attributes(at: indexPath)
    }

    internal func itemAttributesForAppearing(
        at currentIndexPath: IndexPath,
        appearance: ListLayoutAppearance
    ) -> UICollectionViewLayoutAttributes? {
        guard let item = currentState?.item(at: currentIndexPath) else {
            return nil
        }

        if let previousIndexPath = item.indexPath, previousIndexPath != currentIndexPath {
            // Ячейка перемещена: возвращаем обычные аттрибуты предыдущего стейта
            return previousState?
                .sections[previousIndexPath.section]
                .items[previousIndexPath.item]
                .attributes(at: previousIndexPath)
        }

        // Ячейка добавлена или обновлена: возвращаем начальные аттрибуты текущего стейта
        let attributes = item.attributesForAppearing(
            at: currentIndexPath,
            appearance: appearance
        )

        // Если ячейка добавлена, то прихраниваем атрибуты до завершения обновления,
        // чтобы через них обновлять UI-представление при инвалидации
        if item.indexPath == nil {
            itemAnimatedAttributes[currentIndexPath] = attributes
        }

        return attributes
    }

    internal func itemAttributesForDisappearing(
        at previousIndexPath: IndexPath,
        appearance: ListLayoutAppearance
    ) -> UICollectionViewLayoutAttributes? {
        guard let currentState, updateManager.isItemDeletedOrMoved(at: previousIndexPath) else {
            return nil
        }

        let currentIndexPath = itemCurrentIndexPath(at: previousIndexPath)

        if let currentIndexPath, currentIndexPath != previousIndexPath {
            // Ячейка перемещена: возвращаем обычные аттрибуты текущего стейта
            let attributes = currentState
                .sections[currentIndexPath.section]
                .items[currentIndexPath.item]
                .attributes(at: currentIndexPath)

            // Прихраниваем атрибуты до завершения обновления,
            // чтобы через них обновлять UI-представление при инвалидации
            itemAnimatedAttributes[currentIndexPath] = attributes

            return attributes
        }

        // Ячейка удалена или обновлена: возвращаем финальные аттрибуты предыдущего стейта
        return previousState?
            .item(at: previousIndexPath)?
            .attributesForDisappearing(at: previousIndexPath, appearance: appearance)
    }

    internal func headerAttributes(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        currentState?
            .header(at: indexPath.section)?
            .attributes(at: indexPath, boundsProvider: self)
    }

    internal func headerAttributesForAppearing(
        at currentIndexPath: IndexPath,
        appearance: ListLayoutAppearance
    ) -> UICollectionViewLayoutAttributes? {
        let currentIndex = currentIndexPath.section

        guard let section = currentState?.section(at: currentIndex), let header = section.header else {
            return nil
        }

        if let previousIndex = section.index, previousIndex != currentIndex {
            // Cекция перемещена: возвращаем обычные аттрибуты предыдущего стейта
            return previousState?
                .sections[previousIndex]
                .header?
                .attributes(at: IndexPath(section: previousIndex), boundsProvider: self)
        }

        // Секция добавлена или обновлена: возвращаем начальные аттрибуты текущего стейта
        let attributes = header.attributesForAppearing(
            at: currentIndexPath,
            boundsProvider: self,
            appearance: appearance
        )

        // Если секция добавлена, то прихраниваем атрибуты до завершения обновления,
        // чтобы через них обновлять UI-представление при инвалидации
        if section.index == nil {
            headerAnimatedAttributes[currentIndexPath] = attributes
        }

        return attributes
    }

    internal func headerAttributesForDisappearing(
        at previousIndexPath: IndexPath,
        appearance: ListLayoutAppearance
    ) -> UICollectionViewLayoutAttributes? {
        guard let currentState else {
            return nil
        }

        let previousIndex = previousIndexPath.section

        if let currentIndex = sectionCurrentIndex(at: previousIndex), currentIndex != previousIndex {
            // Cекция перемещена: возвращаем обычные аттрибуты текущего стейта
            let currentIndexPath = IndexPath(section: currentIndex)

            let attributes = currentState
                .sections[currentIndex]
                .header?
                .attributes(at: currentIndexPath, boundsProvider: self)

            // Прихраниваем атрибуты до завершения обновления,
            // чтобы через них обновлять UI-представление при инвалидации
            headerAnimatedAttributes[currentIndexPath] = attributes

            return attributes
        }

        // Секция удалена или обновлена: возвращаем финальные аттрибуты предыдущего стейта
        return previousState?
            .header(at: previousIndex)?
            .attributesForDisappearing(
                at: previousIndexPath,
                boundsProvider: self,
                appearance: appearance
            )
    }

    internal func footerAttributes(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        currentState?
            .footer(at: indexPath.section)?
            .attributes(at: indexPath, boundsProvider: self)
    }

    internal func footerAttributesForAppearing(
        at currentIndexPath: IndexPath,
        appearance: ListLayoutAppearance
    ) -> UICollectionViewLayoutAttributes? {
        let currentIndex = currentIndexPath.section

        guard let section = currentState?.section(at: currentIndex), let footer = section.footer else {
            return nil
        }

        if let previousIndex = section.index, previousIndex != currentIndex {
            // Cекция перемещена: возвращаем обычные аттрибуты предыдущего стейта
            return previousState?
                .sections[previousIndex]
                .footer?
                .attributes(at: IndexPath(section: previousIndex), boundsProvider: self)
        }

        // Секция добавлена или обновлена: возвращаем начальные аттрибуты текущего стейта
        let attributes = footer.attributesForAppearing(
            at: currentIndexPath,
            boundsProvider: self,
            appearance: appearance
        )

        // Если секция добавлена, то прихраниваем атрибуты до завершения обновления,
        // чтобы через них обновлять UI-представление при инвалидации
        if section.index == nil {
            footerAnimatedAttributes[currentIndexPath] = attributes
        }

        return attributes
    }

    internal func footerAttributesForDisappearing(
        at previousIndexPath: IndexPath,
        appearance: ListLayoutAppearance
    ) -> UICollectionViewLayoutAttributes? {
        guard let currentState else {
            return nil
        }

        let previousIndex = previousIndexPath.section

        if let currentIndex = sectionCurrentIndex(at: previousIndex), currentIndex != previousIndex {
            // Cекция перемещена: возвращаем обычные аттрибуты текущего стейта
            let currentIndexPath = IndexPath(section: currentIndex)

            let attributes = currentState
                .sections[currentIndex]
                .footer?
                .attributes(at: currentIndexPath, boundsProvider: self)

            // Прихраниваем атрибуты до завершения обновления,
            // чтобы через них обновлять UI-представление при инвалидации
            footerAnimatedAttributes[currentIndexPath] = attributes

            return attributes
        }

        // Секция удалена или обновлена: возвращаем финальные аттрибуты предыдущего стейта
        return previousState?
            .footer(at: previousIndex)?
            .attributesForDisappearing(
                at: previousIndexPath,
                boundsProvider: self,
                appearance: appearance
            )
    }

    internal func attributes(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let sections = currentState?.sections else {
            return nil
        }

        let sectionIndices = sections.indices.lazy.filter { sectionIndex in
            sections[sectionIndex].intersects(rect)
        }

        return sectionIndices.reduce(into: []) { attributes, sectionIndex in
            let section = sections[sectionIndex]

            for itemIndex in section.items.indices {
                let item = section.items[itemIndex]

                if item.intersects(rect) {
                    let indexPath = IndexPath(
                        item: itemIndex,
                        section: sectionIndex
                    )

                    attributes.append(item.attributes(at: indexPath))
                }
            }

            let sectionIndexPath = IndexPath(section: sectionIndex)

            if let header = section.header, header.intersects(rect, boundsProvider: self) {
                attributes.append(header.attributes(at: sectionIndexPath, boundsProvider: self))
            }

            if let footer = section.footer, footer.intersects(rect, boundsProvider: self) {
                attributes.append(footer.attributes(at: sectionIndexPath, boundsProvider: self))
            }
        }
    }

    // MARK: - Invalidation

    internal func invalidateItem(
        at indexPath: IndexPath,
        layout: Layout,
        preferring attributes: UICollectionViewLayoutAttributes? = nil
    ) {
        if let attributes {
            itemAnimatedAttributes[attributes.indexPath]?.update(preferring: attributes)
        }

        updateCurrentState { state in
            state.updateSection(at: indexPath.section) { section in
                section.invalidateItem(at: indexPath.row, preferring: attributes)
            }
        }
    }

    internal func invalidateHeader(
        at index: Int,
        layout: Layout,
        preferring attributes: UICollectionViewLayoutAttributes? = nil
    ) {
        if let attributes {
            headerAnimatedAttributes[attributes.indexPath]?.update(preferring: attributes)
        }

        let shouldUpdatePreviousState = previousState != nil
            && updateManager.isSectionDeletedOrMoved(at: index)
            && !updateManager.isSectionInserted(at: index)

        if shouldUpdatePreviousState {
            updatePreviousState { state in
                state.updateSection(at: index) { section in
                    section.invalidateHeader(preferring: attributes)
                }
            }

            if let currentIndex = sectionCurrentIndex(at: index) {
                updateCurrentState { state in
                    state.updateSection(at: currentIndex) { section in
                        section.invalidateHeader(preferring: attributes)
                    }
                }
            }
        } else {
            updateCurrentState { state in
                state.updateSection(at: index) { section in
                    section.invalidateHeader(preferring: attributes)
                }
            }
        }
    }

    internal func invalidateFooter(
        at index: Int,
        layout: Layout,
        preferring attributes: UICollectionViewLayoutAttributes? = nil
    ) {
        if let attributes {
            footerAnimatedAttributes[attributes.indexPath]?.update(preferring: attributes)
        }

        let shouldUpdatePreviousState = previousState != nil
            && updateManager.isSectionDeletedOrMoved(at: index)
            && !updateManager.isSectionInserted(at: index)

        if shouldUpdatePreviousState {
            updatePreviousState { state in
                state.updateSection(at: index) { section in
                    section.invalidateFooter(preferring: attributes)
                }
            }

            if let currentIndex = sectionCurrentIndex(at: index) {
                updateCurrentState { state in
                    state.updateSection(at: currentIndex) { section in
                        section.invalidateFooter(preferring: attributes)
                    }
                }
            }
        } else {
            updateCurrentState { state in
                state.updateSection(at: index) { section in
                    section.invalidateFooter(preferring: attributes)
                }
            }
        }
    }

    internal func invalidateState(layout: Layout) {
        hasPinnedElements = false

        previousState = nil
        currentState = nil

        resetAnimatedAttributes()
    }

    internal func invalidateStateForUpdates(layout: Layout) {
        previousState = currentState
        currentState = nil
    }

    // MARK: - Preparation

    internal func prepareState(layout: Layout, context: ListLayoutContext) {
        guard currentState != nil || previousState == nil else {
            return
        }

        let previousContentSize = contentSize

        updateCurrentState(invalidating: false) { state in
            let isChanged = layout.updateState(
                &state,
                context: context
            )

            if isChanged {
                state.updateFrames()
            }
        }

        contentSize = currentState?.frame?.size ?? .zero

        updatePreviousState(invalidating: false) { state in
            let isChanged = layout.updateState(
                &state,
                context: context
            )

            if isChanged {
                state.updateFrames()
            }
        }

        if let collectionView, previousContentSize != contentSize {
            delegate?
                .collectionViewLayoutContext(collectionView.collectionViewLayout)?
                .invalidateComponentLayout()
        }
    }

    internal func prepareStateForUpdates(
        layout: Layout,
        context: ListLayoutContext
    ) {
        currentState = previousState ?? currentState

        updateCurrentState { state in
            for (indexPath, item) in updateManager.itemsToReload {
                state.reloadItem(at: indexPath, with: item)
            }

            for (index, section) in updateManager.sectionsToReload {
                state.reloadSection(at: index, with: section)
            }

            for indexPath in updateManager.itemsToDelete {
                state.deleteItem(at: indexPath)
            }

            for index in updateManager.sectionsToDelete {
                state.deleteSection(at: index)
            }

            for (index, section) in updateManager.sectionsToInsert {
                state.insertSection(at: index, with: section)
            }

            for (indexPath, section) in updateManager.itemsToInsert {
                state.insertItem(at: indexPath, with: section)
            }
        }

        prepareState(layout: layout, context: context)
    }

    internal func finalizeStateAfterUpdates() {
        resetAnimatedAttributes()

        if var state = currentState {
            state.updateIndices()

            currentState = state
        }

        previousState = nil
    }
}

extension CollectionViewLayoutStateManager: CollectionViewLayoutBoundsProvider {

    internal func contentBounds(toPinElements: Bool) -> CGRect {
        hasPinnedElements = hasPinnedElements || toPinElements

        return collectionView?.contentBounds ?? .zero
    }
}
#endif
