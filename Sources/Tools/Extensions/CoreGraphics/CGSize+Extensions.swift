import CoreGraphics

extension CGSize {

    internal func isEqual(to other: Self, threshold: CGFloat) -> Bool {
        abs(width - other.width) < threshold && abs(height - other.height) < threshold
    }
}
