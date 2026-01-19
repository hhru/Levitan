#if canImport(UIKit)
import UIKit

public final class FlowView<Layout: FlowLayout>: UIView {

    private var context: ComponentContext?

    private let collectionView: UICollectionView
    private let collectionViewLayout: CollectionViewLayout<Layout>
    private let collectionViewManager: CollectionViewManager<Layout>

    public var collectionViewDelegate: UICollectionViewDelegate? {
        get { collectionViewManager.collectionViewDelegate }
        set { collectionViewManager.collectionViewDelegate = newValue }
    }

    #if os(iOS)
    public var refreshControl: UIRefreshControl? {
        get { collectionView.refreshControl }
        set { collectionView.refreshControl = newValue }
    }
    #endif

    public var contentOffset: CGPoint {
        get { collectionView.contentOffset }
        set { collectionView.contentOffset = newValue }
    }

    public var contentSize: CGSize {
        collectionViewLayout.collectionViewContentSize
    }

    public override var intrinsicContentSize: CGSize {
        let contentSize = contentSize

        guard
            contentSize.width > .leastNonzeroMagnitude,
            contentSize.height > .leastNonzeroMagnitude
        else {
            return super.intrinsicContentSize
        }

        return contentSize.outset(by: collectionView.adjustedContentInset)
    }

    public override init(frame: CGRect) {
        collectionViewLayout = CollectionViewLayout<Layout>()

        collectionView = UICollectionView(
            frame: frame,
            collectionViewLayout: collectionViewLayout
        )

        collectionViewManager = CollectionViewManager(collectionView: collectionView)

        super.init(frame: frame)

        setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        setContentCompressionResistancePriority(.defaultHigh, for: .vertical)

        setContentHuggingPriority(.defaultHigh, for: .horizontal)
        setContentHuggingPriority(.defaultHigh, for: .vertical)

        clipsToBounds = false
        backgroundColor = .clear

        setupCollectionView()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func update(
        with content: Flow<Layout>,
        context: ComponentContext,
        completion: ((_ skipped: Bool) -> Void)?
    ) {
        let context = context.componentLayoutInvalidation { [weak self] in
            self?.invalidateIntrinsicContentSize()
        }

        self.context = context

        updateContentMargins(with: content)

        collectionView.keyboardDismissMode = content.keyboardDismissMode
        collectionView.accessibilityIdentifier = content.accessibilityIdentifier

        #if os(iOS)
        collectionView.isPagingEnabled = content.isPagingEnabled
        #endif

        collectionView.isScrollEnabled = content.isScrollEnabled

        updateScrollIndicator(with: content)
        updateScrollBouncing(with: content)

        collectionViewLayout.layout = content.layout

        collectionViewManager.update(
            strategy: content.updateStrategy,
            sections: content.sections,
            context: context
        ) { skipped in
            completion?(skipped)

            if !skipped {
                content.updateAction?()
            }
        }
    }

    public func reload() {
        collectionView.reloadData()
    }

    public func setContentOffset(_ contentOffset: CGPoint, animated: Bool = true) {
        collectionView.setContentOffset(
            contentOffset,
            animated: animated
        )
    }

    public func scrollToTop(animated: Bool = true) {
        collectionView.layoutIfNeeded()

        let contentOffset = CGPoint(
            x: collectionView.contentOffset.x,
            y: -collectionView.adjustedContentInset.top
        )

        collectionView.setContentOffset(contentOffset, animated: animated)
    }

    public func scrollToBottom(animated: Bool = true) {
        collectionView.layoutIfNeeded()

        let bottomOffset = collectionView.contentSize.height
            - collectionView.frame.size.height
            + collectionView.adjustedContentInset.bottom

        let contentOffset = CGPoint(
            x: collectionView.contentOffset.x,
            y: max(bottomOffset, -collectionView.adjustedContentInset.top)
        )

        collectionView.setContentOffset(contentOffset, animated: animated)
    }

    public func scrollToItem(
        at indexPath: IndexPath,
        anchor: FlowScrollAnchor? = nil,
        animated: Bool = true
    ) {
        guard collectionView.containsIndexPath(indexPath) else {
            return
        }

        collectionView.layoutIfNeeded()

        if let anchor {
            return collectionView.scrollToItem(
                at: indexPath,
                at: anchor.position,
                animated: animated
            )
        }

        if let cell = collectionView.cellForItem(at: indexPath) {
            return collectionView.scrollRectToVisible(
                cell.frame,
                animated: animated
            )
        }

        collectionView.scrollToItem(
            at: indexPath,
            at: [.centeredHorizontally, .centeredVertically],
            animated: animated
        )
    }

    public func scrollToItem(
        where predicate: FlowItemPredicate,
        anchor: FlowScrollAnchor? = nil,
        animated: Bool = true
    ) {
        guard let indexPath = collectionViewManager.itemIndexPath(where: predicate) else {
            return
        }

        scrollToItem(
            at: indexPath,
            anchor: anchor,
            animated: animated
        )
    }

    public func scrollToNextItem(
        after predicate: FlowItemPredicate,
        anchor: FlowScrollAnchor? = nil,
        animated: Bool = true
    ) {
        guard let indexPath = collectionViewManager.nextItemIndexPath(after: predicate) else {
            return
        }

        scrollToItem(
            at: indexPath,
            anchor: anchor,
            animated: animated
        )
    }

    public func scrollToSection(
        where predicate: FlowSectionPredicate<Layout>,
        animated: Bool = true
    ) {
        guard let indexPath = collectionViewManager.sectionIndexPath(where: predicate) else {
            return
        }

        scrollToItem(
            at: indexPath,
            anchor: .top,
            animated: animated
        )
    }

    public func scrollToNextSection(
        after predicate: FlowSectionPredicate<Layout>,
        animated: Bool = true
    ) {
        guard let indexPath = collectionViewManager.nextSectionIndexPath(after: predicate) else {
            return
        }

        scrollToItem(
            at: indexPath,
            anchor: .top,
            animated: animated
        )
    }

    public func focusItem(where predicate: FlowItemPredicate) {
        guard let indexPath = collectionViewManager.itemIndexPath(where: predicate) else {
            return
        }

        collectionView
            .cellForItem(at: indexPath)?
            .becomeFirstResponder()
    }

    public func focusNextItem(after predicate: FlowItemPredicate) {
        guard let indexPath = collectionViewManager.nextItemIndexPath(after: predicate) else {
            return unfocusItem(where: predicate)
        }

        if let cell = collectionView.cellForItem(at: indexPath), cell.canBecomeFirstResponder {
            cell.becomeFirstResponder()
        } else {
            unfocusItem(where: predicate)
        }
    }

    public func unfocusItem(where predicate: FlowItemPredicate) {
        guard let indexPath = collectionViewManager.itemIndexPath(where: predicate) else {
            return
        }

        collectionView
            .cellForItem(at: indexPath)?
            .resignFirstResponder()
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        let previousContentSizeCategory = previousTraitCollection?.preferredContentSizeCategory

        if previousContentSizeCategory != traitCollection.preferredContentSizeCategory {
            collectionViewLayout.invalidateLayout()
        }
    }
}

extension FlowView {

    private func setupCollectionView() {
        addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    private func updateContentMargins(with content: Flow<Layout>) {
        var shouldInvalidateComponentLayout = false

        if collectionView.contentInsetAdjustmentBehavior != content.contentMarginsAdjustmentBehavior {
            collectionView.contentInsetAdjustmentBehavior = content.contentMarginsAdjustmentBehavior

            shouldInvalidateComponentLayout = true
        }

        if collectionView.contentInset != content.contentMargins {
            collectionView.contentInset = content.contentMargins

            collectionView.horizontalScrollIndicatorInsets.left = content.contentMargins.left
            collectionView.horizontalScrollIndicatorInsets.right = content.contentMargins.right

            collectionView.verticalScrollIndicatorInsets.top = content.contentMargins.top
            collectionView.verticalScrollIndicatorInsets.bottom = content.contentMargins.bottom

            shouldInvalidateComponentLayout = true
        }

        if shouldInvalidateComponentLayout {
            context?.invalidateComponentLayout()
        }
    }

    private func updateScrollIndicator(with content: Flow<Layout>) {
        if content.isScrollIndicatorVisible {
            collectionView.showsHorizontalScrollIndicator = collectionViewLayout
                .layout
                .scrollAxis
                .contains(.horizontal)

            collectionView.showsVerticalScrollIndicator = collectionViewLayout
                .layout
                .scrollAxis
                .contains(.vertical)
        } else {
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.showsVerticalScrollIndicator = false
        }
    }

    private func updateScrollBouncing(with content: Flow<Layout>) {
        if content.isScrollAlwaysBouncing {
            collectionView.alwaysBounceHorizontal = collectionViewLayout
                .layout
                .scrollAxis
                .contains(.horizontal)

            collectionView.alwaysBounceVertical = collectionViewLayout
                .layout
                .scrollAxis
                .contains(.vertical)
        } else {
            collectionView.alwaysBounceHorizontal = false
            collectionView.alwaysBounceVertical = false
        }
    }
}

extension FlowView: FallbackComponentView {

    public static func sizing(
        for content: Flow<Layout>,
        fitting size: CGSize,
        context: ComponentContext
    ) -> ComponentSizing {
        let scrollAxis = content.layout.scrollAxis

        return ComponentSizing(
            width: scrollAxis.contains(.horizontal) ? .hug : .fill,
            height: scrollAxis.contains(.vertical) ? .hug : .fill
        )
    }

    public func update(with content: Flow<Layout>, context: ComponentContext) {
        update(with: content, context: context, completion: nil)
    }
}
#endif
