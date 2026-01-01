#if canImport(UIKit)
import UIKit

internal final class CollectionViewLayout<Layout: FlowLayout>: UICollectionViewLayout {

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
                invalidate()
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
        let attributes = stateManager.itemAttributes(at: indexPath)

        print(
            "CollectionViewLayout.\(#function)",
            "IndexPath(row: \(indexPath.row), section: \(indexPath.section))",
            attributes?.frame.height ?? "nil"
        )

        return attributes
    }

    internal override func layoutAttributesForSupplementaryView(
        ofKind elementKind: String,
        at indexPath: IndexPath
    ) -> UICollectionViewLayoutAttributes? {
        print(
            "CollectionViewLayout.\(#function)",
            "IndexPath(section: \(indexPath.section))"
        )

        return switch elementKind {
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
        print(
            "CollectionViewLayout.\(#function)",
            "IndexPath(row: \(indexPath.row), section: \(indexPath.section))"
        )

        return stateManager.itemAttributesForAppearing(
            at: indexPath,
            appearance: layout.appearance
        )
    }

    internal override func finalLayoutAttributesForDisappearingItem(
        at indexPath: IndexPath
    ) -> UICollectionViewLayoutAttributes? {
        print(
            "CollectionViewLayout.\(#function)",
            "IndexPath(row: \(indexPath.row), section: \(indexPath.section))"
        )

        return stateManager.itemAttributesForDisappearing(
            at: indexPath,
            appearance: layout.appearance
        )
    }

    internal override func initialLayoutAttributesForAppearingSupplementaryElement(
        ofKind elementKind: String,
        at indexPath: IndexPath
    ) -> UICollectionViewLayoutAttributes? {
        print(
            "CollectionViewLayout.\(#function)",
            "IndexPath(section: \(indexPath.section))"
        )

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
        print(
            "CollectionViewLayout.\(#function)",
            "IndexPath(section: \(indexPath.section))"
        )

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
        print(
            "CollectionViewLayout.\(#function)",
            "y:", rect.minY,
            "height:", rect.height
        )

        let attributes = stateManager.attributes(in: rect)

        // UICollectionView уточняет размеры видимых ячеек только после вызова `finalizeCollectionViewUpdates()`,
        // и последующая инвалидация ломает анимацию обновления этих ячеек.
        // Поэтому самостоятельно уточняем и инвалидируем размеры видимых ячеек,
        // если атрибуты запрошены в блоке обновления.
        guard let collectionView, updateManager.isUpdating else {
            return attributes
        }

        let visibleItemIndexPaths = collectionView.indexPathsForVisibleItems

        guard !visibleItemIndexPaths.isEmpty else {
            return attributes
        }

        let visibleItemAttributes = attributes?
            .lazy
            .filter { $0.representedElementCategory == .cell }
            .filter { visibleItemIndexPaths.contains($0.indexPath) }
            .filter { $0.sizing != nil } ?? []

        for itemAttributes in visibleItemAttributes {
            guard let cell = collectionView.cellForItem(at: itemAttributes.indexPath) else {
                continue
            }

            guard var newItemAttributes = itemAttributes.copy() as? UICollectionViewLayoutAttributes else {
                continue
            }

            newItemAttributes = cell.preferredLayoutAttributesFitting(newItemAttributes)

            guard itemAttributes.shouldUpdate(preferring: newItemAttributes) else {
                continue
            }

            stateManager.invalidateItem(
                at: itemAttributes.indexPath,
                preferring: newItemAttributes
            )
        }

        guard stateManager.currentState?.isValid != true else {
            return attributes
        }

        stateManager.prepareState(
            layout: layout,
            context: self
        )

        return layoutAttributesForElements(in: rect)
    }

    // MARK: - Preparation

    internal override func prepare() {
        super.prepare()

        guard let collectionView, stateManager.previousState == nil else {
            return
        }

        print("CollectionViewLayout.\(#function)")

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

        print("CollectionViewLayout.\(#function)")

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
        print("CollectionViewLayout.\(#function)")

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

    internal override func prepare(forAnimatedBoundsChange oldBounds: CGRect) {
        super.prepare(forAnimatedBoundsChange: oldBounds)

        print(
            "CollectionViewLayout.\(#function)",
            "oldBounds:", oldBounds,
            "newBounds:", collectionView?.bounds ?? .zero
        )
    }

    internal override func finalizeAnimatedBoundsChange() {
        super.finalizeAnimatedBoundsChange()

        print("CollectionViewLayout.\(#function)")
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
        print(
            "CollectionViewLayout.\(#function)",
            "oldBounds:", collectionView?.bounds ?? .zero,
            "newBounds:", newBounds
        )

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
        print(
            "CollectionViewLayout.\(#function)",
            "preferred:", Unmanaged.passUnretained(preferredAttributes).toOpaque(),
            "original:", Unmanaged.passUnretained(originalAttributes).toOpaque()
        )

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
        print("CollectionViewLayout.\(#function)")

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

        print("CollectionViewLayout.\(#function)")

        if context.invalidateEverything {
            print("CollectionViewLayout.\(#function) -- invalidateEverything")

            return invalidate()
        }

        if let context = context as? CollectionViewLayoutInvalidationContext {
            invalidate(with: context)
        }

        context.invalidatedItemIndexPaths?.forEach { indexPath in
            print("CollectionViewLayout.\(#function) -- invalidatedItemIndexPaths")
            stateManager.invalidateItem(at: indexPath)
        }

        if let supplementaryIndexPaths = context.invalidatedSupplementaryIndexPaths {
            supplementaryIndexPaths[UICollectionView.elementKindSectionHeader]?.forEach { indexPath in
                stateManager.invalidateHeader(at: indexPath.section)
            }

            supplementaryIndexPaths[UICollectionView.elementKindSectionFooter]?.forEach { indexPath in
                stateManager.invalidateFooter(at: indexPath.section)
            }
        }

        if context.invalidateDataSourceCounts {
            print("CollectionViewLayout.\(#function) -- invalidateDataSourceCounts")

            scrollManager.preservePosition(
                state: stateManager.currentState,
                layout: layout
            )

            stateManager.invalidateStateForUpdates()
        }
    }

    internal override func invalidateLayout() {
        print("CollectionViewLayout.\(#function)")

        super.invalidateLayout()
    }

    // MARK: - Scroll

    internal override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        print("CollectionViewLayout.\(#function)")

        return scrollManager.restorePosition(
            state: stateManager.currentState,
            layout: layout,
            finally: stateManager.previousState == nil
        )
    }
}

extension CollectionViewLayout {

    private func invalidate(with context: CollectionViewLayoutInvalidationContext) {
        if context.invalidateContainerSize {
            print("CollectionViewLayout.\(#function) -- invalidateContainerSize")

            return stateManager.invalidateState()
        }

        context
            .itemsPreferredAttributes
            .forEach { stateManager.invalidateItem(at: $0, preferring: $1) }

        context
            .headersPreferredAttributes
            .forEach { stateManager.invalidateHeader(at: $0.section, preferring: $1) }

        context
            .footersPreferredAttributes
            .forEach { stateManager.invalidateFooter(at: $0.section, preferring: $1) }

        let preferredAttributesCount = context.itemsPreferredAttributes.count
            + context.headersPreferredAttributes.count
            + context.footersPreferredAttributes.count

        if let collectionView, preferredAttributesCount > .zero {
            print("CollectionViewLayout.\(#function) -- invalidatePreferringAttributes", preferredAttributesCount)

            let previousContentSize = stateManager.contentSize

            stateManager.prepareState(
                layout: layout,
                context: self
            )

            let contentSize = stateManager.contentSize

            context.contentSizeAdjustment.width = contentSize.width - previousContentSize.width
            context.contentSizeAdjustment.height = contentSize.height - previousContentSize.height

            if stateManager.previousState == nil {
                let scrollPosition = scrollManager.restorePosition(
                    state: stateManager.currentState,
                    layout: layout
                )

                context.contentOffsetAdjustment.x = scrollPosition.x - collectionView.contentOffset.x
                context.contentOffsetAdjustment.y = scrollPosition.y - collectionView.contentOffset.y
            }
        }
    }

    private func invalidate() {
        print("CollectionViewLayout.\(#function)")

        updateManager.reset()

        scrollManager.preservePosition(
            state: stateManager.currentState,
            layout: layout
        )

        stateManager.invalidateState()
    }
}

extension CollectionViewLayout: AnyCollectionViewLayout {

    internal func itemContainerSize(at indexPath: IndexPath) -> CGSize {
        stateManager
            .currentState?
            .item(at: indexPath)?
            .size?
            .actualValue ?? containerSize
    }

    internal func headerContainerSize(at indexPath: IndexPath) -> CGSize {
        stateManager
            .currentState?
            .header(at: indexPath.section)?
            .size?
            .actualValue ?? containerSize
    }

    internal func footerContainerSize(at indexPath: IndexPath) -> CGSize {
        stateManager
            .currentState?
            .footer(at: indexPath.section)?
            .size?
            .actualValue ?? containerSize
    }
}

extension CollectionViewLayout: FlowLayoutContext {

    internal var containerSize: CGSize {
        collectionView?.contentBoundsSize ?? .zero
    }

    internal func itemSize(
        at indexPath: IndexPath,
        proposedSize: CGSize,
        estimatedSize: CGSize
    ) -> FlowLayoutSize {
        let sizing = collectionView
            .flatMap { $0.delegate as? CollectionViewLayoutDelegate }?
            .collectionViewLayout(self, sizingForItemAt: indexPath, fitting: proposedSize)

        guard let sizing else {
            return .actual(.zero)
        }

        return FlowLayoutSize(
            sizing: sizing,
            proposedSize: proposedSize,
            estimatedSize: estimatedSize
        )
    }

    internal func headerSize(
        at index: Int,
        proposedSize: CGSize,
        estimatedSize: CGSize
    ) -> FlowLayoutSize {
        let sizing = collectionView
            .flatMap { $0.delegate as? CollectionViewLayoutDelegate }?
            .collectionViewLayout(self, sizingForHeaderAt: index, fitting: proposedSize)

        guard let sizing else {
            return .actual(.zero)
        }

        return FlowLayoutSize(
            sizing: sizing,
            proposedSize: proposedSize,
            estimatedSize: estimatedSize
        )
    }

    internal func footerSize(
        at index: Int,
        proposedSize: CGSize,
        estimatedSize: CGSize
    ) -> FlowLayoutSize {
        let sizing = collectionView
            .flatMap { $0.delegate as? CollectionViewLayoutDelegate }?
            .collectionViewLayout(self, sizingForFooterAt: index, fitting: proposedSize)

        guard let sizing else {
            return .actual(.zero)
        }

        return FlowLayoutSize(
            sizing: sizing,
            proposedSize: proposedSize,
            estimatedSize: estimatedSize
        )
    }
}
#endif
