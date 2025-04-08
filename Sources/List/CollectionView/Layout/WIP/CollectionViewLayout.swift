#if canImport(UIKit)
import UIKit

internal final class CollectionViewLayout<Layout: ListLayout>: UICollectionViewLayout {

    internal override static var layoutAttributesClass: AnyClass {
        CollectionViewLayoutAttributes.self
    }

    internal override static var invalidationContextClass: AnyClass {
        CollectionViewLayoutInvalidationContext.self
    }

    private let updateManager: CollectionViewLayoutUpdateManager<Layout>
    private let scrollManager: CollectionViewLayoutScrollManager<Layout>
    private let stateManager: CollectionViewLayoutStateManager<Layout>

    internal var layout: Layout = .default {
        didSet {
            if layout != oldValue {
                invalidateLayout()
            }
        }
    }

    internal override var collectionViewContentSize: CGSize {
        stateManager.contentSize
    }

    internal override init() {
        updateManager = CollectionViewLayoutUpdateManager()
        scrollManager = CollectionViewLayoutScrollManager(updateManager: updateManager)
        stateManager = CollectionViewLayoutStateManager(updateManager: updateManager)

        super.init()
    }

    @available(*, unavailable)
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Attributes

    internal override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        stateManager.itemAttributes(at: indexPath)
    }

    internal override func layoutAttributesForSupplementaryView(
        ofKind elementKind: String,
        at indexPath: IndexPath
    ) -> UICollectionViewLayoutAttributes? {
        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            stateManager.headerAttributes(at: indexPath)

        case UICollectionView.elementKindSectionFooter:
            stateManager.footerAttributes(at: indexPath)

        default:
            nil
        }
    }

    internal override func initialLayoutAttributesForAppearingItem(
        at indexPath: IndexPath
    ) -> UICollectionViewLayoutAttributes? {
        stateManager.itemAttributesForAppearing(
            at: indexPath,
            appearance: layout.appearance
        )
    }

    internal override func finalLayoutAttributesForDisappearingItem(
        at indexPath: IndexPath
    ) -> UICollectionViewLayoutAttributes? {
        stateManager.itemAttributesForDisappearing(
            at: indexPath,
            appearance: layout.appearance
        )
    }

    internal override func initialLayoutAttributesForAppearingSupplementaryElement(
        ofKind elementKind: String,
        at indexPath: IndexPath
    ) -> UICollectionViewLayoutAttributes? {
        guard !indexPath.isEmpty else {
            return super.initialLayoutAttributesForAppearingSupplementaryElement(
                ofKind: elementKind,
                at: indexPath
            )
        }

        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            return stateManager.headerAttributesForAppearing(
                at: indexPath,
                appearance: layout.appearance
            )

        case UICollectionView.elementKindSectionFooter:
            return stateManager.footerAttributesForAppearing(
                at: indexPath,
                appearance: layout.appearance
            )

        default:
            return nil
        }
    }

    internal override func finalLayoutAttributesForDisappearingSupplementaryElement(
        ofKind elementKind: String,
        at indexPath: IndexPath
    ) -> UICollectionViewLayoutAttributes? {
        guard !indexPath.isEmpty else {
            return nil
        }

        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            return stateManager.headerAttributesForDisappearing(
                at: indexPath,
                appearance: layout.appearance
            )

        case UICollectionView.elementKindSectionFooter:
            return stateManager.footerAttributesForDisappearing(
                at: indexPath,
                appearance: layout.appearance
            )

        default:
            return nil
        }
    }

    internal override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        stateManager.attributes(in: rect)
    }

    // MARK: - Preparation

    internal override func prepare() {
        super.prepare()

        guard let collectionView, stateManager.previousState == nil else {
            return
        }

        updateManager.collectionView = collectionView
        scrollManager.collectionView = collectionView
        stateManager.collectionView = collectionView

        let previousContentSize = collectionView.contentSize
        let previousScrollPosition = collectionView.contentOffset

        stateManager.prepareState(
            layout: layout,
            context: self
        )

        if previousContentSize.isEqual(to: .zero, threshold: 1.0) {
            let contentSize = stateManager.contentSize

            let scrollPosition = scrollManager.restorePosition(
                state: stateManager.currentState,
                layout: layout
            )

            if !scrollPosition.isEqual(to: previousScrollPosition, threshold: 1.0) {
                let invalidationContext = UICollectionViewLayoutInvalidationContext()

                invalidationContext.contentSizeAdjustment = CGSize(
                    width: contentSize.width - previousContentSize.width,
                    height: contentSize.height - previousContentSize.height
                )

                invalidationContext.contentOffsetAdjustment = CGPoint(
                    x: scrollPosition.x - previousScrollPosition.x,
                    y: scrollPosition.y - previousScrollPosition.y
                )

                invalidateLayout(with: invalidationContext)
            }
        }
    }

    internal override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)

        guard let collectionView else {
            return
        }

        updateManager.collectionView = collectionView
        scrollManager.collectionView = collectionView
        stateManager.collectionView = collectionView

        updateManager.applyUpdates(updateItems, state: stateManager.previousState)

        stateManager.prepareStateForUpdates(
            layout: layout,
            context: self
        )

        scrollManager.preparePositionForUpdates(
            currentState: stateManager.currentState,
            previousState: stateManager.previousState
        )
    }

    internal override func finalizeCollectionViewUpdates() {
        stateManager.finalizeStateAfterUpdates()
        updateManager.reset()

        super.finalizeCollectionViewUpdates()

        guard let collectionView else {
            return scrollManager.reset()
        }

        let previousScrollPosition = collectionView.contentOffset

        let scrollPosition = scrollManager.restorePosition(
            state: stateManager.currentState,
            layout: layout
        )

        if !scrollPosition.isEqual(to: previousScrollPosition, threshold: 1.0) {
            let invalidationContext = UICollectionViewLayoutInvalidationContext()

            invalidationContext.contentOffsetAdjustment = CGPoint(
                x: scrollPosition.x - previousScrollPosition.x,
                y: scrollPosition.y - previousScrollPosition.y
            )

            invalidateLayout(with: invalidationContext)
        }
    }

    // MARK: - Invalidation

    internal override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView else {
            return super.shouldInvalidateLayout(forBoundsChange: newBounds)
        }

        if stateManager.hasPinnedElements {
            return true
        }

        return !newBounds.size.isEqual(
            to: collectionView.bounds.size,
            threshold: 1.0
        )
    }

    internal override func invalidationContext(
        forBoundsChange newBounds: CGRect
    ) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds)

        guard let collectionView, let context = context as? CollectionViewLayoutInvalidationContext else {
            return context
        }

        if !newBounds.size.isEqual(to: collectionView.bounds.size, threshold: 1.0) {
            context.invalidateContainerSize = true

            scrollManager.preservePosition(
                state: stateManager.currentState,
                layout: layout
            )
        }

        return context
    }

    internal override func shouldInvalidateLayout(
        forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes,
        withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes
    ) -> Bool {
        guard !preferredAttributes.indexPath.isEmpty else {
            return super.shouldInvalidateLayout(
                forPreferredLayoutAttributes: preferredAttributes,
                withOriginalAttributes: originalAttributes
            )
        }

        guard let originalAttributes = originalAttributes as? CollectionViewLayoutAttributes else {
            return super.shouldInvalidateLayout(
                forPreferredLayoutAttributes: preferredAttributes,
                withOriginalAttributes: originalAttributes
            )
        }

        return originalAttributes.shouldUpdate(preferring: preferredAttributes)
    }

    internal override func invalidationContext(
        forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes,
        withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes
    ) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(
            forPreferredLayoutAttributes: preferredAttributes,
            withOriginalAttributes: originalAttributes
        )

        guard let context = context as? CollectionViewLayoutInvalidationContext else {
            return context
        }

        switch preferredAttributes.representedElementCategory {
        case .cell:
            context.invalidateItem(
                at: preferredAttributes.indexPath,
                preferring: preferredAttributes
            )

        case .supplementaryView:
            switch preferredAttributes.representedElementKind {
            case UICollectionView.elementKindSectionHeader:
                context.invalidateHeader(
                    at: preferredAttributes.indexPath,
                    preferring: preferredAttributes
                )

            case UICollectionView.elementKindSectionFooter:
                context.invalidateFooter(
                    at: preferredAttributes.indexPath,
                    preferring: preferredAttributes
                )

            default:
                break
            }

        default:
            break
        }

        scrollManager.preservePosition(
            state: stateManager.currentState,
            layout: layout
        )

        return context
    }

    internal override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        defer { super.invalidateLayout(with: context) }

        if context.invalidateEverything {
            updateManager.reset()

            scrollManager.preservePosition(
                state: stateManager.currentState,
                layout: layout
            )

            return stateManager.invalidateState(layout: layout)
        }

        if let context = context as? CollectionViewLayoutInvalidationContext {
            invalidateLayout(with: context)
        }

        context.invalidatedItemIndexPaths?.forEach { indexPath in
            stateManager.invalidateItem(at: indexPath, layout: layout)
        }

        if let supplementaryIndexPaths = context.invalidatedSupplementaryIndexPaths {
            supplementaryIndexPaths[UICollectionView.elementKindSectionHeader]?.forEach { indexPath in
                stateManager.invalidateHeader(at: indexPath.section, layout: layout)
            }

            supplementaryIndexPaths[UICollectionView.elementKindSectionFooter]?.forEach { indexPath in
                stateManager.invalidateFooter(at: indexPath.section, layout: layout)
            }
        }

        if context.invalidateDataSourceCounts {
            scrollManager.preservePosition(
                state: stateManager.currentState,
                layout: layout
            )

            stateManager.invalidateStateForUpdates(layout: layout)
        }
    }

    // MARK: - Scroll

    internal override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        scrollManager.restorePosition(
            state: stateManager.currentState,
            layout: layout,
            finally: stateManager.previousState == nil
        )
    }
}

extension CollectionViewLayout {

    private func invalidateLayout(with context: CollectionViewLayoutInvalidationContext) {
        if context.invalidateContainerSize {
            stateManager.invalidateState(layout: layout)
        }

        context
            .itemsPreferredAttributes
            .forEach { stateManager.invalidateItem(at: $0, layout: layout, preferring: $1) }

        context
            .headersPreferredAttributes
            .forEach { stateManager.invalidateHeader(at: $0.section, layout: layout, preferring: $1) }

        context
            .footersPreferredAttributes
            .forEach { stateManager.invalidateFooter(at: $0.section, layout: layout, preferring: $1) }

        let preferredAttributesCount = context.itemsPreferredAttributes.count
            + context.headersPreferredAttributes.count
            + context.footersPreferredAttributes.count

        if let collectionView, preferredAttributesCount > .zero {
            stateManager.prepareState(
                layout: layout,
                context: self
            )

            if stateManager.previousState == nil {
                let contentSize = stateManager.contentSize

                let scrollPosition = scrollManager.restorePosition(
                    state: stateManager.currentState,
                    layout: layout
                )

                context.contentSizeAdjustment.width = contentSize.width - collectionView.contentSize.width
                context.contentSizeAdjustment.height = contentSize.height - collectionView.contentSize.height

                context.contentOffsetAdjustment.x = scrollPosition.x - collectionView.contentOffset.x
                context.contentOffsetAdjustment.y = scrollPosition.y - collectionView.contentOffset.y
            }
        }
    }
}

extension CollectionViewLayout: AnyCollectionViewLayout {

    internal func itemContainerSize(at indexPath: IndexPath) -> CGSize {
        stateManager
            .currentState?
            .item(at: indexPath)?
            .size?
            .value ?? containerSize
    }

    internal func headerContainerSize(at indexPath: IndexPath) -> CGSize {
        stateManager
            .currentState?
            .header(at: indexPath.section)?
            .size?
            .value ?? containerSize
    }

    internal func footerContainerSize(at indexPath: IndexPath) -> CGSize {
        stateManager
            .currentState?
            .footer(at: indexPath.section)?
            .size?
            .value ?? containerSize
    }
}

extension CollectionViewLayout: ListLayoutContext {

    internal var containerSize: CGSize {
        collectionView?.contentBoundsSize ?? .zero
    }

    internal func itemSize(
        at indexPath: IndexPath,
        proposedSize: CGSize,
        estimatedSize: CGSize
    ) -> ListLayoutSize {
        let sizing = collectionView
            .flatMap { $0.delegate as? CollectionViewLayoutDelegate }?
            .collectionViewLayout(self, sizingForItemAt: indexPath, fitting: proposedSize)

        guard let sizing else {
            return .actual(.zero)
        }

        return ListLayoutSize(
            sizing: sizing,
            proposedSize: proposedSize,
            estimatedSize: estimatedSize
        )
    }

    internal func headerSize(
        at index: Int,
        proposedSize: CGSize,
        estimatedSize: CGSize
    ) -> ListLayoutSize {
        let sizing = collectionView
            .flatMap { $0.delegate as? CollectionViewLayoutDelegate }?
            .collectionViewLayout(self, sizingForHeaderAt: index, fitting: proposedSize)

        guard let sizing else {
            return .actual(.zero)
        }

        return ListLayoutSize(
            sizing: sizing,
            proposedSize: proposedSize,
            estimatedSize: estimatedSize
        )
    }

    internal func footerSize(
        at index: Int,
        proposedSize: CGSize,
        estimatedSize: CGSize
    ) -> ListLayoutSize {
        let sizing = collectionView
            .flatMap { $0.delegate as? CollectionViewLayoutDelegate }?
            .collectionViewLayout(self, sizingForFooterAt: index, fitting: proposedSize)

        guard let sizing else {
            return .actual(.zero)
        }

        return ListLayoutSize(
            sizing: sizing,
            proposedSize: proposedSize,
            estimatedSize: estimatedSize
        )
    }
}
#endif
