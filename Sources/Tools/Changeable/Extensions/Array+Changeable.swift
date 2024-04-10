import Foundation

extension Array: Changeable {

    internal typealias ChangeableCopy = Self
}

extension Array where Element: Changeable {

    internal subscript(changing index: Index) -> Element.ChangeableCopy {
        get { self[index].changeableCopy }
        set { self[index] = Element(copy: newValue) }
    }
}
