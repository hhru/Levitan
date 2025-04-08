#if canImport(UIKit)
import UIKit

public struct ListLayoutSection<Layout: ListLayout> {

    internal var index: Int?
    internal var frame: CGRect?

    public var origin: CGPoint?
    public var size: CGSize?

    public private(set) var items: [ListLayoutItem]
    public private(set) var header: ListLayoutHeader?
    public private(set) var footer: ListLayoutFooter?

    public private(set) var metrics: Layout.Metrics?

    internal func intersects(_ rect: CGRect) -> Bool {
        frame?.intersects(rect) ?? false
    }

    internal mutating func reloadItem(at index: Int, with item: ListLayoutItem) {
        items[index] = item

        size = nil
    }

    internal mutating func deleteItem(at index: Int) {
        items.remove(at: index)

        if index < items.count {
            items[index].origin = nil
        } else {
            footer?.origin = nil
        }

        size = nil
    }

    internal mutating func insertItem(at index: Int, with item: ListLayoutItem) {
        if index < items.count {
            items[index].origin = nil
        } else {
            footer?.origin = nil
        }

        items.insert(item, at: index)

        size = nil
    }

    internal mutating func invalidateItem(
        at index: Int,
        preferring attributes: UICollectionViewLayoutAttributes?
    ) {
        items[index].invalidate(preferring: attributes)

        size = nil
    }

    internal mutating func invalidateHeader(preferring attributes: UICollectionViewLayoutAttributes?) {
        header?.invalidate(preferring: attributes)

        size = nil
    }

    internal mutating func invalidateFooter(preferring attributes: UICollectionViewLayoutAttributes?) {
        footer?.invalidate(preferring: attributes)

        size = nil
    }

    internal mutating func updateIndices(index: Int) {
        self.index = index

        items.withUnsafeMutableBufferPointer { items in
            for itemIndex in items.indices {
                items[itemIndex].indexPath = IndexPath(
                    item: itemIndex,
                    section: index
                )
            }
        }
    }

    internal mutating func updateFrames(offset: CGPoint) {
        let origin = offset.offset(by: origin ?? .zero)
        let size = size ?? .zero

        frame = CGRect(
            origin: origin,
            size: size
        )

        items.withUnsafeMutableBufferPointer { items in
            for itemIndex in items.indices {
                items[itemIndex].updateFrame(offset: origin)
            }
        }

        header?.updateFrame(offset: origin)
        footer?.updateFrame(offset: origin)
    }
}

extension ListLayoutSection {

    public mutating func updateItem(
        at index: Int,
        using body: (inout ListLayoutItem) -> Void
    ) {
        items.withUnsafeMutableBufferPointer { items in
            body(&items[index])
        }
    }

    public mutating func updateHeader(using body: (inout ListLayoutHeader) -> Void) {
        guard var header else {
            return
        }

        body(&header)

        self.header = header
    }

    public mutating func updateFooter(using body: (inout ListLayoutFooter) -> Void) {
        guard var footer else {
            return
        }

        body(&footer)

        self.footer = footer
    }
}
#endif
