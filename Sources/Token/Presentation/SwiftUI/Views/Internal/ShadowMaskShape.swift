import SwiftUI

internal struct ShadowMaskShape: Shape {

    internal let shadow: ShadowValue

    internal let shape: ShapeValue
    internal let shapeInsets: CGFloat

    private func dropShadowPath(in rect: CGRect) -> Path {
        let insets = shapeInsets
            - shadow.spread
            - shadow.radius * 2.0
            - 4.0

        let externalRect = CGRect(
            x: shadow.offset.width + insets,
            y: shadow.offset.height + insets,
            width: rect.width - 2.0 * insets,
            height: rect.height - 2.0 * insets
        )

        let externalPath = CGPath(rect: externalRect, transform: nil)
        let internalPath = shape.path(size: rect.size, insets: shapeInsets)

        let path: CGPath

        if #available(iOS 16.0, tvOS 16.0, *) {
            path = externalPath.subtracting(internalPath)
        } else {
            let bezierPath = UIBezierPath()

            bezierPath.append(UIBezierPath(cgPath: externalPath))
            bezierPath.append(UIBezierPath(cgPath: internalPath).reversing())

            path = bezierPath.cgPath
        }

        return Path(path).offsetBy(
            dx: rect.minX,
            dy: rect.minY
        )
    }

    private func innerShadowPath(in rect: CGRect) -> Path {
        let path = shape.path(
            size: rect.size,
            insets: shapeInsets
        )

        return Path(path).offsetBy(
            dx: rect.minX,
            dy: rect.minY
        )
    }

    internal func path(in rect: CGRect) -> Path {
        switch shadow.type {
        case .drop:
            dropShadowPath(in: rect)

        case .inner:
            innerShadowPath(in: rect)
        }
    }
}
