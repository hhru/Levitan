import CoreGraphics

extension CGPoint {

    internal func isEqual(to other: Self, threshold: CGFloat) -> Bool {
        abs(x - other.x) < threshold && abs(y - other.y) < threshold
    }

    internal func squaredDistance(to other: Self) -> CGFloat {
        let vectorX = other.x - x
        let vectorY = other.y - y

        return vectorX * vectorX + vectorY * vectorY
    }

    internal func offset(by offset: Self) -> Self {
        Self(
            x: x + offset.x,
            y: y + offset.y
        )
    }

    internal func negate() -> Self {
        Self(x: -x, y: -y)
    }
}
