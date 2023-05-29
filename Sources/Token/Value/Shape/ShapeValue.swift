import CoreGraphics

public enum ShapeValue: TokenValue, Sendable {

    case custom(CustomShape)

    public func path(size: CGSize, insets: CGFloat = .zero) -> CGPath {
        switch self {
        case let .custom(shape):
            shape.path(size: size, insets: insets)
        }
    }
}

extension ShapeValue: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.custom(lhs), .custom(rhs)):
            return lhs.isEqual(to: rhs)
        }
    }
}

extension ShapeValue: Hashable {

    public func hash(into hasher: inout Hasher) {
        switch self {
        case let .custom(shape):
            shape.hash(into: &hasher)
        }
    }
}
