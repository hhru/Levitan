#if canImport(UIKit)
import Foundation

public struct FlowSection<Layout: FlowLayout>: Equatable, Sendable {

    public let id: ComponentID

    public let items: [AnyFlowItem]
    public var header: AnyFlowHeader?
    public var footer: AnyFlowFooter?

    public var metrics: Layout.Metrics

    private init(
        id: some Hashable & Sendable,
        items: [AnyFlowItem],
        header: AnyFlowHeader?,
        footer: AnyFlowFooter?,
        metrics: Layout.Metrics
    ) {
        self.id = ComponentID(id)

        self.items = items
        self.header = header
        self.footer = footer

        self.metrics = metrics
    }

    public init(
        id: some Hashable & Sendable,
        items: [any FlowItem],
        header: (any FlowHeader)? = nil,
        footer: (any FlowFooter)? = nil,
        metrics: Layout.Metrics = .default
    ) {
        self.init(
            id: id,
            items: items.map { $0.eraseToAnyItem() },
            header: header?.eraseToAnyHeader(),
            footer: footer?.eraseToAnyFooter(),
            metrics: metrics
        )
    }

    public init(
        item: any FlowItem,
        header: (any FlowHeader)? = nil,
        footer: (any FlowFooter)? = nil,
        metrics: Layout.Metrics = .default
    ) {
        self.init(
            id: item.id,
            items: [item.eraseToAnyItem()],
            header: header?.eraseToAnyHeader(),
            footer: footer?.eraseToAnyFooter(),
            metrics: metrics
        )
    }

    public init(
        id: some Hashable & Sendable,
        header: (any FlowHeader)? = nil,
        footer: (any FlowFooter)? = nil,
        metrics: Layout.Metrics = .default,
        @FlowSectionBuilder items: () -> [any FlowItem]
    ) {
        self.init(
            id: id,
            items: items()
        )
    }
}

extension FlowSection: Changeable {

    public func header(_ header: (any FlowHeader)?) -> Self {
        changing { $0.header = header?.eraseToAnyHeader() }
    }

    public func footer(_ footer: (any FlowFooter)?) -> Self {
        changing { $0.footer = footer?.eraseToAnyFooter() }
    }

    public func metrics(_ metrics: Layout.Metrics) -> Self {
        changing { $0.metrics = metrics }
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

    internal func items(_ items: [AnyFlowItem]) -> Self {
        Self(
            id: id,
            items: items,
            header: header,
            footer: footer,
            metrics: metrics
        )
    }
}
#endif
