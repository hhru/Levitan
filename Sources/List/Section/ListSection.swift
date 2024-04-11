import Foundation

public struct ListSection<Layout: ListLayout>: Equatable {

    public let identifier: AnyHashable

    public let items: [ListSectionItem]
    public let header: ListSectionHeader?
    public let footer: ListSectionFooter?

    public let metrics: Layout.Metrics

    private init(
        identifier: AnyHashable,
        items: [ListSectionItem],
        header: ListSectionHeader?,
        footer: ListSectionFooter?,
        metrics: Layout.Metrics = .default
    ) {
        self.identifier = identifier

        self.items = items
        self.header = header
        self.footer = footer

        self.metrics = metrics
    }

    public init(
        identifier: AnyHashable,
        items: [AnyListItem],
        header: AnyListHeader? = nil,
        footer: AnyListFooter? = nil,
        metrics: Layout.Metrics = .default
    ) {
        self.init(
            identifier: identifier,
            items: items.map { $0.sectionItem },
            header: header?.sectionHeader,
            footer: footer?.sectionFooter,
            metrics: metrics
        )
    }

    public init(
        identifierFile: String = #fileID,
        identifierLine: Int = #line,
        items: [AnyListItem],
        header: AnyListHeader? = nil,
        footer: AnyListFooter? = nil,
        metrics: Layout.Metrics = .default
    ) {
        self.init(
            identifier: "\(identifierFile):\(identifierLine)",
            items: items.map { $0.sectionItem },
            header: header?.sectionHeader,
            footer: footer?.sectionFooter,
            metrics: metrics
        )
    }

    public init(
        item: AnyListItem,
        header: AnyListHeader? = nil,
        footer: AnyListFooter? = nil,
        metrics: Layout.Metrics = .default
    ) {
        self.init(
            identifier: item.identifier,
            items: [item.sectionItem],
            header: header?.sectionHeader,
            footer: footer?.sectionFooter,
            metrics: metrics
        )
    }

    public init(
        identifier: AnyHashable,
        @ListSectionBuilder items: () -> [AnyListItem]
    ) {
        self.init(
            identifier: identifier,
            items: items()
        )
    }

    public init(
        identifierFile: String = #fileID,
        identifierLine: Int = #line,
        @ListSectionBuilder items: () -> [AnyListItem]
    ) {
        self.init(
            identifier: "\(identifierFile):\(identifierLine)",
            items: items()
        )
    }
}

extension ListSection: Changeable {

    internal init(copy: ChangeableWrapper<Self>) {
        self.init(
            identifier: copy.identifier,
            items: copy.items,
            header: copy.header,
            footer: copy.footer,
            metrics: copy.metrics
        )
    }

    public func header(_ header: AnyListHeader?) -> Self {
        changing { $0.header = header?.sectionHeader }
    }

    public func footer(_ footer: AnyListFooter?) -> Self {
        changing { $0.footer = footer?.sectionFooter }
    }

    public func metrics(_ metrics: Layout.Metrics) -> Self {
        changing { $0.metrics = metrics }
    }
}

extension ListSection: DiffableSection {

    internal var differenceIdentifier: AnyHashable {
        identifier
    }

    internal func isContentEqual(to other: ListSection<Layout>) -> Bool {
        header == other.header
            && footer == other.footer
            && metrics == other.metrics
    }

    internal func items(_ items: [ListSectionItem]) -> Self {
        Self(
            identifier: identifier,
            items: items,
            header: header,
            footer: footer,
            metrics: metrics
        )
    }
}
