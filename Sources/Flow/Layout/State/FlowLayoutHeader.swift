#if canImport(UIKit)
import UIKit

public struct FlowLayoutHeader {

    internal var frame: ((_ boundsProvider: CollectionViewLayoutBoundsProvider) -> CGRect)?

    public var origin: FlowLayoutOrigin?
    public var size: FlowLayoutSize?

    public var zIndex: Int?
    public var alpha: CGFloat?
    public var transform: CGAffineTransform?

    public var isValid: Bool {
        origin != nil && size != nil
    }
}

extension FlowLayoutHeader {

    @MainActor
    internal func intersects(
        _ rect: CGRect,
        boundsProvider: CollectionViewLayoutBoundsProvider
    ) -> Bool {
        frame?(boundsProvider).intersects(rect) ?? false
    }

    @MainActor
    internal func attributes(
        at indexPath: IndexPath,
        boundsProvider: CollectionViewLayoutBoundsProvider,
        reusing cachedAttributes: CollectionViewLayoutAttributes? = nil
    ) -> CollectionViewLayoutAttributes {
        let attributes: CollectionViewLayoutAttributes

        if let cachedAttributes, cachedAttributes.indexPath == indexPath {
            attributes = cachedAttributes
        } else {
            attributes = CollectionViewLayoutAttributes(
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                with: indexPath
            )
        }

        attributes.frame = frame?(boundsProvider) ?? .zero

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

    @MainActor
    internal func attributesForAppearing(
        at indexPath: IndexPath,
        boundsProvider: CollectionViewLayoutBoundsProvider,
        appearance: FlowLayoutAppearance
    ) -> CollectionViewLayoutAttributes {
        var state = self

        appearance.configureHeaderForAppearing(
            &state,
            at: indexPath
        )

        return state.attributes(
            at: indexPath,
            boundsProvider: boundsProvider
        )
    }

    @MainActor
    internal func attributesForDisappearing(
        at indexPath: IndexPath,
        boundsProvider: CollectionViewLayoutBoundsProvider,
        appearance: FlowLayoutAppearance
    ) -> CollectionViewLayoutAttributes {
        var state = self

        appearance.configureHeaderForDisappearing(
            &state,
            at: indexPath
        )

        return state.attributes(
            at: indexPath,
            boundsProvider: boundsProvider
        )
    }

    @MainActor
    internal mutating func updateFrame(offset: CGPoint) {
        let size = size?.value ?? .zero

        switch origin {
        case let .normal(origin):
            let origin = origin.offset(by: offset)

            frame = { _ in
                CGRect(origin: origin, size: size)
            }

        case let .pinned(origin):
            frame = { boundsProvider in
                let bounds = boundsProvider
                    .contentBounds(toPinElements: true)
                    .offset(by: offset.negate())

                let origin = origin(bounds).offset(by: offset)

                return CGRect(origin: origin, size: size)
            }

        case nil:
            frame = { _ in
                CGRect(origin: offset, size: size)
            }
        }
    }

    @MainActor
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

    @MainActor
    internal mutating func invalidate() {
        origin = nil
        size = nil

        zIndex = nil
        alpha = nil
        transform = nil
    }
}
#endif
