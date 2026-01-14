#if canImport(UIKit)
import Foundation

public struct Flow<Layout: FlowLayout>: Sendable {

    public typealias Section = FlowSection<Layout>

    public let sections: [Section]
    public var layout: Layout

    public var accessibilityIdentifier: String?

    #if os(iOS)
    public var isPagingEnabled: Bool
    #endif

    public var isScrollEnabled: Bool
    public var isScrollIndicatorVisible: Bool
    public var isScrollAlwaysBouncing: Bool

    public var updateStrategy: FlowUpdateStrategy

    @ViewAction
    public var updateAction: (@Sendable @MainActor () -> Void)?

    #if os(iOS)
    public init(
        sections: [Section],
        layout: Layout = .default,
        accessibilityIdentifier: String? = nil,
        isPagingEnabled: Bool = false,
        isScrollEnabled: Bool = true,
        isScrollIndicatorVisible: Bool = true,
        isScrollAlwaysBouncing: Bool = false,
        updateStrategy: FlowUpdateStrategy = .update,
        updateAction: (@Sendable @MainActor () -> Void)? = nil
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
        updateStrategy: FlowUpdateStrategy = .update,
        updateAction: (@Sendable @MainActor () -> Void)? = nil
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
        updateStrategy: FlowUpdateStrategy = .update,
        updateAction: (@Sendable @MainActor () -> Void)? = nil
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
        updateStrategy: FlowUpdateStrategy = .update,
        updateAction: (@Sendable @MainActor () -> Void)? = nil
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

    public init(@FlowBuilder<Layout> sections: () -> [Section]) {
        self.init(sections: sections())
    }

    public init(items: [any FlowItem]) {
        self.init(
            section: Section(
                id: items.first?.id,
                items: items
            )
        )
    }

    public init(item: any FlowItem) {
        self.init(items: [item])
    }

    public init(@FlowSectionBuilder items: () -> [any FlowItem]) {
        self.init(items: items())
    }
}

extension Flow: FallbackComponent {

    public typealias UIView = FlowView<Layout>
}

extension Flow: Changeable {

    public func layout(_ layout: Layout) -> Self {
        changing { $0.layout = layout }
    }

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

    public func updateStrategy(_ updateStrategy: FlowUpdateStrategy) -> Self {
        changing { $0.updateStrategy = updateStrategy }
    }

    public func onUpdate(_ action: (@Sendable @MainActor () -> Void)?) -> Self {
        guard let action else {
            return self
        }

        let newAction = { @Sendable @MainActor [updateAction] in
            updateAction?()
            action()
        }

        return changing { $0.updateAction = newAction }
    }
}

extension Flow {

    public static var empty: Self {
        Self(sections: [])
    }
}
#endif
