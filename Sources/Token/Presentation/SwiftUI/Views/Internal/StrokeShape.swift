#if canImport(UIKit)
import UIKit
import SwiftUI

internal struct StrokeShape: Shape {

    internal let stroke: StrokeValue
    internal let shape: ShapeValue

    private func path(in rect: CGRect, insets: CGFloat) -> CGPath {
        let path = shape.path(size: rect.size, insets: insets)

        var translation = CGAffineTransform(
            translationX: rect.minX,
            y: rect.minY
        )

        return path.copy(using: &translation) ?? path
    }

    internal func path(in rect: CGRect) -> Path {
        let insets = stroke.insets

        let externalPath = path(in: rect, insets: insets)
        let internalPath = path(in: rect, insets: insets + stroke.width)

        if #available(iOS 16.0, tvOS 16.0, *) {
            return Path(externalPath.subtracting(internalPath))
        }

        let bezierPath = UIBezierPath()

        bezierPath.append(UIBezierPath(cgPath: externalPath))
        bezierPath.append(UIBezierPath(cgPath: internalPath).reversing())

        return Path(bezierPath.cgPath)
    }
}
#endif
