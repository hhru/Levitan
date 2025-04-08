#if canImport(UIKit)
import UIKit

public struct ListLayoutItem {

    internal var indexPath: IndexPath?
    internal var frame: CGRect?

    public var origin: CGPoint?
    public var size: ListLayoutSize?

    public var zIndex: Int?
    public var alpha: CGFloat?
    public var transform: CGAffineTransform?

    public var previousSize: CGSize? {
        frame?.size
    }

    internal func intersects(_ rect: CGRect) -> Bool {
        frame?.intersects(rect) ?? false
    }

    internal func attributes(at indexPath: IndexPath) -> CollectionViewLayoutAttributes {
        let attributes = CollectionViewLayoutAttributes(forCellWith: indexPath)

        attributes.frame = frame ?? .zero

        attributes.zIndex = zIndex ?? .zero
        attributes.alpha = alpha ?? 1.0
        attributes.transform = transform ?? .identity

        switch size {
        case .actual, nil:
            attributes.sizing = nil

        case let .estimated(_, sizing, proposedSize):
            attributes.sizing = CollectionViewLayoutSizing(
                width: sizing.width,
                height: sizing.height,
                proposedSize: proposedSize
            )
        }

        return attributes
    }

    internal func attributesForAppearing(
        at indexPath: IndexPath,
        appearance: ListLayoutAppearance
    ) -> CollectionViewLayoutAttributes {
        var state = self

        appearance.configureItemForAppearing(
            &state,
            at: indexPath
        )

        return state.attributes(at: indexPath)
    }

    internal func attributesForDisappearing(
        at indexPath: IndexPath,
        appearance: ListLayoutAppearance
    ) -> CollectionViewLayoutAttributes {
        var state = self

        appearance.configureItemForDisappearing(
            &state,
            at: indexPath
        )

        return state.attributes(at: indexPath)
    }

    internal mutating func updateFrame(offset: CGPoint) {
        let origin = offset.offset(by: origin ?? .zero)
        let size = size?.value ?? .zero

        frame = CGRect(origin: origin, size: size)
    }

    internal mutating func invalidate(preferring attributes: UICollectionViewLayoutAttributes?) {
        guard let attributes else {
            return invalidate()
        }

        switch size {
        case .actual:
            break

        case .estimated, nil:
            origin = nil
            size = .actual(attributes.frame.size)
        }
    }

    internal mutating func invalidate() {
        origin = nil
        size = nil

        zIndex = nil
        alpha = nil
        transform = nil
    }
}
#endif
