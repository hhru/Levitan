#if canImport(UIKit)
import SwiftUI

extension Flow {

    public init<Data: RandomAccessCollection, ID: Hashable & Sendable>(
        _ data: Data,
        sections: @escaping (Data.Element) -> some Component
    ) where Data.Element: Identifiable, Data.Element.ID == ID {
        self.init(
            items: data.map { element in
                sections(element).flowItem(id: element.id)
            }
        )
    }

    public init<Data: RandomAccessCollection, ID: Hashable & Sendable>(
        _ data: Data,
        id: KeyPath<Data.Element, ID>,
        items: @escaping (Data.Element) -> some Component
    ) {
        self.init(
            items: data.map { element in
                items(element).flowItem(id: element[keyPath: id])
            }
        )
    }

    public init<Data: RandomAccessCollection, ID: Hashable & Sendable>(
        _ data: Data,
        items: @escaping (Data.Element) -> some Component
    ) where Data.Element: Identifiable, Data.Element.ID == ID {
        self.init(
            items: data.map { element in
                items(element).flowItem(id: element.id)
            }
        )
    }
}
#endif
