import CoreGraphics

extension CGRect {

    internal func offset(by offset: CGPoint) -> Self {
        offsetBy(dx: offset.x, dy: offset.y)
    }
}
