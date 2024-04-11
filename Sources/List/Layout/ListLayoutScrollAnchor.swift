import CoreGraphics

public struct ListLayoutScrollAnchor: Equatable {

    public let x: CGFloat
    public let y: CGFloat

    private init(
        x: CGFloat,
        y: CGFloat
    ) {
        self.x = x
        self.y = y
    }
}

extension ListLayoutScrollAnchor {

    public static let topLeading = Self(x: .zero, y: .zero)
    public static let top = Self(x: 0.5, y: .zero)
    public static let topTrailing = Self(x: 1.0, y: .zero)

    public static let leading = Self(x: .zero, y: 0.5)
    public static let center = Self(x: 0.5, y: 0.5)
    public static let trailing = Self(x: 1.0, y: 0.5)

    public static let bottomLeading = Self(x: .zero, y: 1.0)
    public static let bottom = Self(x: 0.5, y: 1.0)
    public static let bottomTrailing = Self(x: 1.0, y: 1.0)
}
