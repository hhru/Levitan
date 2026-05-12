import CoreGraphics
import SwiftUI

public struct AnyShapeValue: TokenValue, Sendable {

    private var wrapped: any ShapeValue

    public init<Wrapped: ShapeValue>(_ wrapped: Wrapped) {
        self.wrapped = wrapped
    }

    public func path(size: CGSize, insets: CGFloat = .zero) -> CGPath {
        wrapped.path(size: size, insets: insets)
    }
}

extension AnyShapeValue: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.wrapped.isEqual(to: rhs.wrapped)
    }
}

extension AnyShapeValue: Hashable {

    public func hash(into hasher: inout Hasher) {
        wrapped.hash(into: &hasher)
    }
}

extension AnyShapeValue: Animatable {

    public var animatableData: AnyShapeAnimatableData {
        get { wrapped.anyAnimatableData }
        set { wrapped.anyAnimatableData = newValue }
    }
}

extension AnyShapeValue: Shape {

    public func path(in rect: CGRect) -> Path {
        let path = wrapped.path(
            size: rect.size,
            insets: .zero
        )

        return Path(path).offsetBy(
            dx: rect.minX,
            dy: rect.minY
        )
    }
}
