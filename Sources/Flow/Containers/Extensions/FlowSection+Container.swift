#if canImport(UIKit)
import SwiftUI

extension FlowSection {

    public init<Data: RandomAccessCollection, ID: Hashable & Sendable>(
        id: some Hashable & Sendable,
        itemsData: Data,
        itemsID: KeyPath<Data.Element, ID>,
        items: @escaping (Data.Element) -> some Component
    ) {
        self.init(
            id: id,
            items: itemsData.map { element in
                items(element).flowItem(id: element[keyPath: itemsID])
            }
        )
    }

    public init<Data: RandomAccessCollection, ID: Hashable & Sendable>(
        id: some Hashable & Sendable,
        itemsData: Data,
        items: @escaping (Data.Element) -> some Component
    ) where Data.Element: Identifiable, Data.Element.ID == ID {
        self.init(
            id: id,
            items: itemsData.map { element in
                items(element).flowItem(id: element.id)
            }
        )
    }
}
#endif
