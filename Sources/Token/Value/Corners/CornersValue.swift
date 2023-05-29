import Foundation

public struct CornersValue:
    TokenValue,
    ExpressibleByIntegerLiteral,
    ExpressibleByFloatLiteral,
    Sendable {

    public let topLeft: CGFloat
    public let topRight: CGFloat
    public let bottomLeft: CGFloat
    public let bottomRight: CGFloat

    public var isRectangular: Bool {
        topLeft == .zero
            && topRight == .zero
            && bottomLeft == .zero
            && bottomRight == .zero
    }

    public init(
        topLeft: CGFloat = .zero,
        topRight: CGFloat = .zero,
        bottomLeft: CGFloat = .zero,
        bottomRight: CGFloat = .zero
    ) {
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomLeft = bottomLeft
        self.bottomRight = bottomRight
    }

    public init(
        radius: CGFloat,
        mask: CornersMask = .all
    ) {
        self.init(
            topLeft: mask.contains(.topLeft) ? radius : .zero,
            topRight: mask.contains(.topRight) ? radius : .zero,
            bottomLeft: mask.contains(.bottomLeft) ? radius : .zero,
            bottomRight: mask.contains(.bottomRight) ? radius : .zero
        )
    }

    public init(integerLiteral radius: Int) {
        self.init(radius: CGFloat(radius))
    }

    public init(floatLiteral radius: Double) {
        self.init(radius: CGFloat(radius))
    }
}

extension CornersValue {

    public static var rectangular: Self {
        rounded(radius: .zero)
    }

    public static func rounded(radius: CGFloat, mask: CornersMask = .all) -> Self {
        Self(radius: radius, mask: mask)
    }
}
