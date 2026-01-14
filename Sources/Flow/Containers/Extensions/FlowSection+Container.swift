#if canImport(UIKit)
import SwiftUI

extension FlowSection {

    public init<Data: RandomAccessCollection, ID: Hashable & Sendable>(
        id: some Hashable & Sendable,
        metrics: Layout.Metrics = .default,
        header: (any View & Equatable)? = nil,
        footer: (any View & Equatable)? = nil,
        itemsData: Data,
        itemsID: KeyPath<Data.Element, ID>,
        items: (Data.Element) -> (any View & Equatable)?
    ) {
        self.init(
            id: id,
            metrics: metrics,
            header: header?.anyFlowHeader(),
            footer: footer?.anyFlowFooter(),
            items: itemsData.compactMap { element in
                items(element)?.anyFlowItem(id: element[keyPath: itemsID])
            }
        )
    }

    public init<Data: RandomAccessCollection, ID: Hashable & Sendable>(
        id: some Hashable & Sendable,
        metrics: Layout.Metrics = .default,
        header: (any View & Equatable)? = nil,
        footer: (any View & Equatable)? = nil,
        itemsData: Data,
        items: (Data.Element) -> (any View & Equatable)?
    ) where Data.Element: Identifiable, Data.Element.ID == ID {
        self.init(
            id: id,
            metrics: metrics,
            header: header?.anyFlowHeader(),
            footer: footer?.anyFlowFooter(),
            items: itemsData.compactMap { element in
                items(element)?.anyFlowItem(id: element.id)
            }
        )
    }

    public init(
        id: some Hashable & Sendable,
        metrics: Layout.Metrics = .default,
        header: (any View & Equatable)? = nil,
        footer: (any View & Equatable)? = nil,
        itemsData: Range<Int>,
        items: (Int) -> (any View & Equatable)?
    ) {
        self.init(
            id: id,
            metrics: metrics,
            header: header?.anyFlowHeader(),
            footer: footer?.anyFlowFooter(),
            items: itemsData.compactMap { index in
                items(index)?.anyFlowItem(id: index)
            }
        )
    }
}

extension FlowSection {

    public func header(_ header: (any View & Equatable)?) -> Self {
        self.header(header?.anyFlowHeader())
    }

    public func footer(_ footer: (any View & Equatable)?) -> Self {
        self.footer(footer?.anyFlowFooter())
    }
}
#endif
