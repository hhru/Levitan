#if canImport(UIKit)
import SwiftUI

extension Flow {

    public init<Data: RandomAccessCollection, ID: Hashable & Sendable>(
        _ data: Data,
        sections: (Data.Element) -> Section?
    ) where Data.Element: Identifiable, Data.Element.ID == ID {
        self.init(sections: data.compactMap(sections))
    }

    public init(
        _ data: Range<Int>,
        sections: (Int) -> Section?
    ) {
        self.init(sections: data.compactMap(sections))
    }

    public init<Data: RandomAccessCollection, ID: Hashable & Sendable>(
        metrics: Layout.Metrics = .default,
        header: (any View & Equatable)? = nil,
        footer: (any View & Equatable)? = nil,
        itemsData: Data,
        itemsID: KeyPath<Data.Element, ID>,
        items: (Data.Element) -> (any View & Equatable)?
    ) {
        self.init(
            metrics: metrics,
            header: header?.anyFlowHeader(),
            footer: footer?.anyFlowFooter(),
            items: itemsData.compactMap { element in
                items(element)?.anyFlowItem(id: element[keyPath: itemsID])
            }
        )
    }

    public init<Data: RandomAccessCollection, ID: Hashable & Sendable>(
        metrics: Layout.Metrics = .default,
        header: (any View & Equatable)? = nil,
        footer: (any View & Equatable)? = nil,
        itemsData: Data,
        items: (Data.Element) -> (any View & Equatable)?
    ) where Data.Element: Identifiable, Data.Element.ID == ID {
        self.init(
            metrics: metrics,
            header: header?.anyFlowHeader(),
            footer: footer?.anyFlowFooter(),
            items: itemsData.compactMap { element in
                items(element)?.anyFlowItem(id: element.id)
            }
        )
    }

    public init(
        metrics: Layout.Metrics = .default,
        header: (any View & Equatable)? = nil,
        footer: (any View & Equatable)? = nil,
        itemsData: Range<Int>,
        items: (Int) -> (any View & Equatable)?
    ) {
        self.init(
            metrics: metrics,
            header: header?.anyFlowHeader(),
            footer: footer?.anyFlowFooter(),
            items: itemsData.compactMap { index in
                items(index)?.anyFlowItem(id: index)
            }
        )
    }
}
#endif
