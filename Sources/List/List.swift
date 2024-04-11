import UIKit

public struct List<Layout: ListLayout>: FallbackComponent {

    public typealias UIView = ListView<Layout>
    public typealias Section = ListSection<Layout>

    public let layout: Layout
    public let sections: [Section]

    public let accessibilityIdentifier: String?

    public let isPagingEnabled: Bool
    public let isScrollEnabled: Bool
    public let isScrollIndicatorVisible: Bool
    public let isScrollAlwaysBouncing: Bool

    public let updateStrategy: ListUpdateStrategy

    @ViewAction
    public var updateAction: (() -> Void)?

    public init(
        layout: Layout = .default,
        sections: [Section],
        accessibilityIdentifier: String? = nil,
        isPagingEnabled: Bool = false,
        isScrollEnabled: Bool = true,
        isScrollIndicatorVisible: Bool = true,
        isScrollAlwaysBouncing: Bool = false,
        updateStrategy: ListUpdateStrategy = .update,
        updateAction: (() -> Void)? = nil
    ) {
        self.layout = layout
        self.sections = sections

        self.accessibilityIdentifier = accessibilityIdentifier

        self.isPagingEnabled = isPagingEnabled
        self.isScrollEnabled = isScrollEnabled
        self.isScrollIndicatorVisible = isScrollIndicatorVisible
        self.isScrollAlwaysBouncing = isScrollAlwaysBouncing

        self.updateStrategy = updateStrategy

        self.updateAction = updateAction
    }

    public init(
        layout: Layout = .default,
        section: Section,
        accessibilityIdentifier: String? = nil,
        isPagingEnabled: Bool = false,
        isScrollEnabled: Bool = true,
        isScrollIndicatorVisible: Bool = true,
        isScrollAlwaysBouncing: Bool = false,
        updateStrategy: ListUpdateStrategy = .update,
        updateAction: (() -> Void)? = nil
    ) {
        self.init(
            layout: layout,
            sections: [section],
            accessibilityIdentifier: accessibilityIdentifier,
            isPagingEnabled: isPagingEnabled,
            isScrollEnabled: isScrollEnabled,
            isScrollIndicatorVisible: isScrollIndicatorVisible,
            isScrollAlwaysBouncing: isScrollAlwaysBouncing,
            updateStrategy: updateStrategy,
            updateAction: updateAction
        )
    }

    public init(
        layout: Layout = .default,
        @ListBuilder<Layout> sections: () -> [Section]
    ) {
        self.init(
            layout: layout,
            sections: sections()
        )
    }

    public init(
        layout: Layout = .default,
        items: [AnyListItem]
    ) {
        self.init(
            layout: layout,
            section: Section(items: items)
        )
    }

    public init(
        layout: Layout = .default,
        item: AnyListItem
    ) {
        self.init(
            layout: layout,
            section: Section(item: item)
        )
    }

    public init(
        layout: Layout = .default,
        @ListSectionBuilder items: () -> [AnyListItem]
    ) {
        self.init(
            layout: layout,
            items: items()
        )
    }
}

extension List: Changeable {

    internal init(copy: ChangeableWrapper<Self>) {
        self.init(
            layout: copy.layout,
            sections: copy.sections,
            accessibilityIdentifier: copy.accessibilityIdentifier,
            isPagingEnabled: copy.isPagingEnabled,
            isScrollEnabled: copy.isScrollEnabled,
            isScrollIndicatorVisible: copy.isScrollIndicatorVisible,
            isScrollAlwaysBouncing: copy.isScrollAlwaysBouncing,
            updateStrategy: copy.updateStrategy,
            updateAction: copy.updateAction
        )
    }

    public func accessibilityIdentifier(_ accessibilityIdentifier: String?) -> Self {
        changing { $0.accessibilityIdentifier = accessibilityIdentifier }
    }

    public func pagingDisabled(_ isPagingDisabled: Bool = true) -> Self {
        changing { $0.isPagingEnabled = $0.isPagingEnabled && !isPagingDisabled }
    }

    public func scrollDisabled(_ isScrollDisabled: Bool = true) -> Self {
        changing { $0.isScrollEnabled = $0.isScrollEnabled && !isScrollDisabled }
    }

    public func scrollIndicator(_ isScrollIndicatorVisible: Bool = true) -> Self {
        changing { $0.isScrollIndicatorVisible = isScrollIndicatorVisible }
    }

    public func scrollAlwaysBounces(_ isScrollAlwaysBouncing: Bool = true) -> Self {
        changing { $0.isScrollAlwaysBouncing = isScrollAlwaysBouncing }
    }

    public func updateStrategy(_ updateStrategy: ListUpdateStrategy) -> Self {
        changing { $0.updateStrategy = updateStrategy }
    }

    public func onUpdate(_ updateAction: @escaping () -> Void) -> Self {
        changing { $0.updateAction = updateAction }
    }
}
