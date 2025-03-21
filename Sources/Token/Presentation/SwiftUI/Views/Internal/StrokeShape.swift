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

    private func generateSolidPath(in rect: CGRect) -> CGPath {
        let insets = stroke.insets

        let externalPath = path(in: rect, insets: insets)
        let internalPath = path(in: rect, insets: insets + stroke.width)

        if #available(iOS 16.0, tvOS 16.0, *) {
            return externalPath.subtracting(internalPath)
        }

        let bezierPath = UIBezierPath()

        bezierPath.append(UIBezierPath(cgPath: externalPath))
        bezierPath.append(UIBezierPath(cgPath: internalPath).reversing())

        return bezierPath.cgPath
    }

    private func generateDashedPath(in rect: CGRect) -> CGPath {
        let externalPath = path(in: rect, insets: stroke.insets)

        return externalPath
            .copy(dashingWithPhase: stroke.style.dashPhase, lengths: stroke.style.dash)
            .copy(
                strokingWithWidth: stroke.width,
                lineCap: stroke.style.lineCap,
                lineJoin: stroke.style.lineJoin,
                miterLimit: stroke.style.miterLimit
            )
    }

    internal func path(in rect: CGRect) -> Path {
        Path(stroke.isDashed ? generateDashedPath(in: rect) : generateSolidPath(in: rect))
    }
}
#endif
