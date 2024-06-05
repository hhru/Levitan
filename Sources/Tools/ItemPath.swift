import Foundation

internal struct ItemPath: Hashable {

    internal var index: Int
    internal var section: Int

    internal var indexPath: IndexPath {
        IndexPath(item: index, section: section)
    }

    internal init(index: Int, section: Int) {
        self.index = index
        self.section = section
    }

    internal init(indexPath: IndexPath) {
        self.index = indexPath.item
        self.section = indexPath.section
    }
}
