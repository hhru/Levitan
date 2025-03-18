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

    private func generatePath(in rect: CGRect) -> Path {
        let insets = stroke.insets
        let externalPath = path(in: rect, insets: insets)

        return Path(externalPath)
    }

    internal func path(in rect: CGRect) -> Path {
        generatePath(in: rect)
            .strokedPath(
                StrokeStyle(
                    lineWidth: stroke.width,
                    lineCap: stroke.style.lineCap,
                    lineJoin: stroke.style.lineJoin,
                    miterLimit: stroke.style.miterLimit,
                    dash: stroke.style.dash,
                    dashPhase: stroke.style.dashPhase
                )
            )
    }
}

#endif
