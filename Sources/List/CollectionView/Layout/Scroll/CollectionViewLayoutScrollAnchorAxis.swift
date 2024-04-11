import CoreGraphics

internal struct CollectionViewLayoutScrollAnchorAxis {

    private let origin: KeyPath<CGRect, CGFloat>
    private let size: KeyPath<CGRect, CGFloat>

    internal func origin(of rect: CGRect) -> CGFloat {
        rect[keyPath: origin]
    }

    internal func size(of rect: CGRect) -> CGFloat {
        rect[keyPath: size]
    }
}

extension CollectionViewLayoutScrollAnchorAxis {

    internal static let horizontal = Self(
        origin: \.origin.x,
        size: \.size.width
    )

    internal static let vertical = Self(
        origin: \.origin.y,
        size: \.size.height
    )
}
