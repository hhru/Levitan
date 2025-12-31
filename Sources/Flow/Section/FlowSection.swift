#if canImport(UIKit)
import Foundation

public struct FlowSection<Layout: FlowLayout>: Equatable, Sendable {

    public let identifier: FlowIdentifier
    public let items: [AnyFlowItem]

    public var header: AnyFlowHeader?
    public var footer: AnyFlowFooter?

    public var metrics: Layout.Metrics

    private init(
        identifier: some Hashable & Sendable,
        items: [AnyFlowItem],
        header: AnyFlowHeader?,
        footer: AnyFlowFooter?,
        metrics: Layout.Metrics = .default
    ) {
        self.identifier = FlowIdentifier(identifier)
        self.items = items

        self.header = header
        self.footer = footer
        self.metrics = metrics
    }

    public init(
        identifier: some Hashable & Sendable,
        items: [any FlowItem],
        header: (any FlowHeader)? = nil,
        footer: (any FlowFooter)? = nil,
        metrics: Layout.Metrics = .default
    ) {
        self.init(
            identifier: identifier,
            items: items.map { $0.eraseToAnyItem() },
            header: header?.eraseToAnyHeader(),
            footer: footer?.eraseToAnyFooter(),
            metrics: metrics
        )
    }

    public init(
        identifierFile: String = #fileID,
        identifierLine: Int = #line,
        items: [any FlowItem],
        header: (any FlowHeader)? = nil,
        footer: (any FlowFooter)? = nil,
        metrics: Layout.Metrics = .default
    ) {
        self.init(
            identifier: "\(identifierFile):\(identifierLine)",
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
            identifier: item.identifier,
            items: [item.eraseToAnyItem()],
            header: header?.eraseToAnyHeader(),
            footer: footer?.eraseToAnyFooter(),
            metrics: metrics
        )
    }

    public init(
        identifier: some Hashable & Sendable,
        @FlowSectionBuilder items: () -> [any FlowItem]
    ) {
        self.init(
            identifier: identifier,
            items: items()
        )
    }

    public init(
        identifierFile: String = #fileID,
        identifierLine: Int = #line,
        @FlowSectionBuilder items: () -> [any FlowItem]
    ) {
        self.init(
            identifierFile: identifierFile,
            identifierLine: identifierLine,
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

    internal var differenceIdentifier: AnyHashable {
        identifier
    }

    internal func isContentEqual(to other: Self) -> Bool {
        header == other.header
            && footer == other.footer
            && metrics == other.metrics
    }

    internal func items(_ items: [AnyFlowItem]) -> Self {
        Self(
            identifier: identifier,
            items: items,
            header: header,
            footer: footer,
            metrics: metrics
        )
    }
}
#endif
