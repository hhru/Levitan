#if canImport(UIKit)
import UIKit

public struct List<Layout: ListLayout>: FallbackComponent {

    public typealias UIView = ListView<Layout>
    public typealias Section = ListSection<Layout>

    public let sections: [Section]
    public var layout: Layout

    public var accessibilityIdentifier: String?

    #if os(iOS)
    public var isPagingEnabled: Bool
    #endif

    public var isScrollEnabled: Bool
    public var isScrollIndicatorVisible: Bool
    public var isScrollAlwaysBouncing: Bool

    public var updateStrategy: ListUpdateStrategy

    @ViewAction
    public var updateAction: (() -> Void)?

    #if os(iOS)
    public init(
        sections: [Section],
        layout: Layout = .default,
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
    #else
    public init(
        sections: [Section],
        layout: Layout = .default,
        accessibilityIdentifier: String? = nil,
        isScrollEnabled: Bool = true,
        isScrollIndicatorVisible: Bool = true,
        isScrollAlwaysBouncing: Bool = false,
        updateStrategy: ListUpdateStrategy = .update,
        updateAction: (() -> Void)? = nil
    ) {
        self.layout = layout
        self.sections = sections

        self.accessibilityIdentifier = accessibilityIdentifier

        self.isScrollEnabled = isScrollEnabled
        self.isScrollIndicatorVisible = isScrollIndicatorVisible
        self.isScrollAlwaysBouncing = isScrollAlwaysBouncing

        self.updateStrategy = updateStrategy

        self.updateAction = updateAction
    }
    #endif

    #if os(iOS)
    public init(
        section: Section,
        layout: Layout = .default,
        accessibilityIdentifier: String? = nil,
        isPagingEnabled: Bool = false,
        isScrollEnabled: Bool = true,
        isScrollIndicatorVisible: Bool = true,
        isScrollAlwaysBouncing: Bool = false,
        updateStrategy: ListUpdateStrategy = .update,
        updateAction: (() -> Void)? = nil
    ) {
        self.init(
            sections: [section],
            layout: layout,
            accessibilityIdentifier: accessibilityIdentifier,
            isPagingEnabled: isPagingEnabled,
            isScrollEnabled: isScrollEnabled,
            isScrollIndicatorVisible: isScrollIndicatorVisible,
            isScrollAlwaysBouncing: isScrollAlwaysBouncing,
            updateStrategy: updateStrategy,
            updateAction: updateAction
        )
    }
    #else
    public init(
        section: Section,
        layout: Layout = .default,
        accessibilityIdentifier: String? = nil,
        isScrollEnabled: Bool = true,
        isScrollIndicatorVisible: Bool = true,
        isScrollAlwaysBouncing: Bool = false,
        updateStrategy: ListUpdateStrategy = .update,
        updateAction: (() -> Void)? = nil
    ) {
        self.init(
            sections: [section],
            layout: layout,
            accessibilityIdentifier: accessibilityIdentifier,
            isScrollEnabled: isScrollEnabled,
            isScrollIndicatorVisible: isScrollIndicatorVisible,
            isScrollAlwaysBouncing: isScrollAlwaysBouncing,
            updateStrategy: updateStrategy,
            updateAction: updateAction
        )
    }
    #endif

    public init(
        layout: Layout = .default,
        @ListBuilder<Layout> sections: () -> [Section]
    ) {
        self.init(
            sections: sections(),
            layout: layout
        )
    }

    public init(
        items: [AnyListItem],
        layout: Layout = .default
    ) {
        self.init(
            section: Section(items: items),
            layout: layout
        )
    }

    public init(
        item: AnyListItem,
        layout: Layout = .default
    ) {
        self.init(
            section: Section(item: item),
            layout: layout
        )
    }

    public init(
        layout: Layout = .default,
        @ListSectionBuilder items: () -> [AnyListItem]
    ) {
        self.init(
            items: items(),
            layout: layout
        )
    }
}

extension List: Changeable {

    public func accessibilityIdentifier(_ accessibilityIdentifier: String?) -> Self {
        changing { $0.accessibilityIdentifier = accessibilityIdentifier }
    }

    #if os(iOS)
    public func pagingDisabled(_ isPagingDisabled: Bool = true) -> Self {
        changing { $0.isPagingEnabled = !isPagingDisabled }
    }
    #endif

    public func scrollDisabled(_ isScrollDisabled: Bool = true) -> Self {
        changing { $0.isScrollEnabled = !isScrollDisabled }
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

extension List {

    public static var empty: Self {
        Self(sections: [])
    }
}
#endif
