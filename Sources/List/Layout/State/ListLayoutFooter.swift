import UIKit

public struct ListLayoutFooter {

    internal var frame: ((_ boundsProvider: CollectionViewLayoutBoundsProvider) -> CGRect)?

    public var origin: ListLayoutOrigin?
    public var size: ListLayoutSize?

    public var zIndex: Int?
    public var alpha: CGFloat?
    public var transform: CGAffineTransform?

    internal func intersects(
        _ rect: CGRect,
        boundsProvider: CollectionViewLayoutBoundsProvider
    ) -> Bool {
        frame?(boundsProvider).intersects(rect) ?? false
    }

    internal func attributes(
        at indexPath: IndexPath,
        boundsProvider: CollectionViewLayoutBoundsProvider
    ) -> CollectionViewLayoutAttributes {
        let attributes = CollectionViewLayoutAttributes(
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            with: indexPath
        )

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

    internal func attributesForAppearing(
        at indexPath: IndexPath,
        boundsProvider: CollectionViewLayoutBoundsProvider,
        appearance: ListLayoutAppearance
    ) -> CollectionViewLayoutAttributes {
        var state = self

        appearance.configureFooterForAppearing(
            &state,
            at: indexPath
        )

        return state.attributes(
            at: indexPath,
            boundsProvider: boundsProvider
        )
    }

    internal func attributesForDisappearing(
        at indexPath: IndexPath,
        boundsProvider: CollectionViewLayoutBoundsProvider,
        appearance: ListLayoutAppearance
    ) -> CollectionViewLayoutAttributes {
        var state = self

        appearance.configureFooterForDisappearing(
            &state,
            at: indexPath
        )

        return state.attributes(
            at: indexPath,
            boundsProvider: boundsProvider
        )
    }

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
        frame = nil

        origin = nil
        size = nil

        zIndex = nil
        alpha = nil
        transform = nil
    }
}
