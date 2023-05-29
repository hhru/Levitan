import SwiftUI

internal struct ShadowShape: Shape {

    internal let shadow: ShadowValue

    internal let shape: ShapeValue
    internal let shapeInsets: CGFloat

    private func dropShadowParh(in rect: CGRect) -> Path {
        let path = shape.path(
            size: rect.size,
            insets: shapeInsets - shadow.spread
        )

        return Path(path).offsetBy(
            dx: rect.minX,
            dy: rect.minY
        )
    }

    private func innerShadowPath(in rect: CGRect) -> Path {
        let externalRectInsets = shapeInsets
            - shadow.radius * 2.0
            - shadow.spread
            - 4.0

        let externalRect = CGRect(
            x: externalRectInsets,
            y: externalRectInsets,
            width: rect.width - 2.0 * externalRectInsets,
            height: rect.height - 2.0 * externalRectInsets
        )

        let externalPath = CGPath(rect: externalRect, transform: nil)

        let internalPath = shape.path(
            size: rect.size,
            insets: shapeInsets + shadow.spread
        )

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

    internal func path(in rect: CGRect) -> Path {
        switch shadow.type {
        case .drop:
            dropShadowParh(in: rect)

        case .inner:
            innerShadowPath(in: rect)
        }
    }
}
