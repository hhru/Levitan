import Foundation

extension Array: Changeable {

    public typealias ChangeableCopy = Self
}

extension Array where Element: Changeable {

    public subscript(changing index: Index) -> Element.ChangeableCopy {
        get { self[index].changeableCopy }
        set { self[index] = Element(copy: newValue) }
    }
}
