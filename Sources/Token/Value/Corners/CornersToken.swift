import Foundation

public typealias CornersToken = Token<CornersValue>

extension CornersToken {

    public init(
        topLeft: CornerRadiusToken = .zero,
        topRight: CornerRadiusToken = .zero,
        bottomLeft: CornerRadiusToken = .zero,
        bottomRight: CornerRadiusToken = .zero
    ) {
        self = Token(traits: [topLeft, topRight, bottomLeft, bottomRight]) { theme in
            Value(
                topLeft: topLeft.resolve(for: theme),
                topRight: topRight.resolve(for: theme),
                bottomLeft: bottomLeft.resolve(for: theme),
                bottomRight: bottomRight.resolve(for: theme)
            )
        }
    }

    public init(
        radius: CornerRadiusToken,
        mask: CornersMask = .all
    ) {
        self.init(
            topLeft: mask.contains(.topLeft) ? radius : .zero,
            topRight: mask.contains(.topRight) ? radius : .zero,
            bottomLeft: mask.contains(.bottomLeft) ? radius : .zero,
            bottomRight: mask.contains(.bottomRight) ? radius : .zero
        )
    }
}

extension CornersToken {

    public static var rectangular: Self {
        rounded(radius: .zero)
    }

    public static func rounded(radius: CornerRadiusToken, mask: CornersMask = .all) -> Self {
        Self(radius: radius, mask: mask)
    }
}
