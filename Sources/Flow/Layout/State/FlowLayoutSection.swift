#if canImport(UIKit)
import UIKit

public struct FlowLayoutSection<Layout: FlowLayout> {

    internal var index: Int?
    internal var frame: CGRect?

    public var origin: CGPoint?
    public var size: CGSize?

    public private(set) var items: [FlowLayoutItem]

    public private(set) var header: FlowLayoutHeader?
    public private(set) var footer: FlowLayoutFooter?

    public private(set) var metrics: Layout.Metrics?

    public var isValid: Bool {
        origin != nil && size != nil
    }

    public mutating func updateItem(at index: Int, using body: (inout FlowLayoutItem) -> Void) {
        items.withUnsafeMutableBufferPointer { items in
            body(&items[index])
        }
    }

    public mutating func updateHeader(using body: (inout FlowLayoutHeader) -> Void) {
        guard var header else {
            return
        }

        body(&header)

        self.header = header
    }

    public mutating func updateFooter(using body: (inout FlowLayoutFooter) -> Void) {
        guard var footer else {
            return
        }

        body(&footer)

        self.footer = footer
    }
}

extension FlowLayoutSection {

    @MainActor
    internal func intersects(_ rect: CGRect) -> Bool {
        frame?.intersects(rect) ?? false
    }

    @MainActor
    internal mutating func reloadItem(at index: Int, with item: FlowLayoutItem) {
        items[index] = item

        size = nil
    }

    @MainActor
    internal mutating func deleteItem(at index: Int) {
        items.remove(at: index)

        if index < items.count {
            items[index].origin = nil
        } else {
            footer?.origin = nil
        }

        size = nil
    }

    @MainActor
    internal mutating func insertItem(at index: Int, with item: FlowLayoutItem) {
        if index < items.count {
            items[index].origin = nil
        } else {
            footer?.origin = nil
        }

        items.insert(item, at: index)

        size = nil
    }

    @MainActor
    internal mutating func invalidateItem(
        at index: Int,
        preferring attributes: UICollectionViewLayoutAttributes?
    ) {
        items[index].invalidate(preferring: attributes)

        size = nil
    }

    @MainActor
    internal mutating func invalidateHeader(preferring attributes: UICollectionViewLayoutAttributes?) {
        header?.invalidate(preferring: attributes)

        size = nil
    }

    @MainActor
    internal mutating func invalidateFooter(preferring attributes: UICollectionViewLayoutAttributes?) {
        footer?.invalidate(preferring: attributes)

        size = nil
    }

    @MainActor
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

    @MainActor
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
#endif
