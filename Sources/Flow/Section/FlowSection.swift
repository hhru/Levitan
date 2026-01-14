#if canImport(UIKit)
import Foundation

public struct FlowSection<Layout: FlowLayout>: Equatable, Sendable {

    public let id: ComponentID

    internal var metrics: Layout.Metrics
    internal var header: FlowSectionHeader?
    internal var footer: FlowSectionFooter?

    internal let items: [FlowSectionItem]

    private init(
        id: some Hashable & Sendable,
        metrics: Layout.Metrics,
        header: FlowSectionHeader?,
        footer: FlowSectionFooter?,
        items: [FlowSectionItem]
    ) {
        self.id = ComponentID(id)

        self.metrics = metrics
        self.header = header
        self.footer = footer

        self.items = items
    }

    public init(
        id: some Hashable & Sendable,
        metrics: Layout.Metrics = .default,
        header: (any FlowHeader)? = nil,
        footer: (any FlowFooter)? = nil,
        items: [any FlowItem]
    ) {
        self.init(
            id: id,
            metrics: metrics,
            header: header?.sectionHeader(),
            footer: footer?.sectionFooter(),
            items: items.map { $0.sectionItem() }
        )
    }

    public init(
        metrics: Layout.Metrics = .default,
        header: (any FlowHeader)? = nil,
        footer: (any FlowFooter)? = nil,
        item: any FlowItem
    ) {
        self.init(
            id: item.id,
            metrics: metrics,
            header: header,
            footer: footer,
            items: [item]
        )
    }

    public init(
        id: some Hashable & Sendable,
        metrics: Layout.Metrics = .default,
        header: (any FlowHeader)? = nil,
        footer: (any FlowFooter)? = nil,
        @FlowItemArrayBuilder items: () -> [any FlowItem]
    ) {
        self.init(
            id: id,
            metrics: metrics,
            header: header,
            footer: footer,
            items: items()
        )
    }
}

extension FlowSection: Changeable {

    public func metrics(_ metrics: Layout.Metrics) -> Self {
        changing { $0.metrics = metrics }
    }

    public func header(_ header: (any FlowHeader)?) -> Self {
        changing { $0.header = header?.sectionHeader() }
    }

    public func footer(_ footer: (any FlowFooter)?) -> Self {
        changing { $0.footer = footer?.sectionFooter() }
    }
}

extension FlowSection: DiffableSection {

    internal var differenceID: AnyHashable {
        id
    }

    internal func isContentEqual(to other: Self) -> Bool {
        header == other.header
            && footer == other.footer
            && metrics == other.metrics
    }

    internal func items(_ items: [FlowSectionItem]) -> Self {
        Self(
            id: id,
            metrics: metrics,
            header: header,
            footer: footer,
            items: items
        )
    }
}
#endif
