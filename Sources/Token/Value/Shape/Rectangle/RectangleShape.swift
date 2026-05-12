import CoreGraphics
import SwiftUI

public struct RectangleShape: Hashable {

    public var corners: CornersValue

    public init(corners: CornersValue) {
        self.corners = corners
    }
}

extension RectangleShape {

    private func addTopLeftArc(
        to path: CGMutablePath,
        corners: CornersValue,
        size: CGSize,
        insets: CGFloat
    ) {
        let maxRadius = 0.5 * min(size.width, size.height)
        let radius = min(corners.topLeft, maxRadius)
        let arcRadius = radius - insets

        guard radius > .leastNonzeroMagnitude, arcRadius > .leastNonzeroMagnitude else {
            return path.addLine(to: CGPoint(x: insets, y: insets))
        }

        path.addLine(to: CGPoint(x: insets, y: radius))

        path.addArc(
            center: CGPoint(x: radius, y: radius),
            radius: arcRadius,
            startAngle: .pi,
            endAngle: .pi * 1.5,
            clockwise: false
        )
    }

    private func addTopRightArc(
        to path: CGMutablePath,
        corners: CornersValue,
        size: CGSize,
        insets: CGFloat
    ) {
        let maxRadius = 0.5 * min(size.width, size.height)
        let radius = min(corners.topRight, maxRadius)
        let arcRadius = radius - insets

        guard radius > .leastNonzeroMagnitude, arcRadius > .leastNonzeroMagnitude else {
            return path.addLine(to: CGPoint(x: size.width - insets, y: insets))
        }

        path.addLine(to: CGPoint(x: size.width - radius, y: insets))

        path.addArc(
            center: CGPoint(x: size.width - radius, y: radius),
            radius: arcRadius,
            startAngle: .pi * 1.5,
            endAngle: .pi * 2.0,
            clockwise: false
        )
    }

    private func addBottomRightArc(
        to path: CGMutablePath,
        corners: CornersValue,
        size: CGSize,
        insets: CGFloat
    ) {
        let maxRadius = 0.5 * min(size.width, size.height)
        let radius = min(corners.bottomRight, maxRadius)
        let arcRadius = radius - insets

        guard radius > .leastNonzeroMagnitude, arcRadius > .leastNonzeroMagnitude else {
            return path.addLine(to: CGPoint(x: size.width - insets, y: size.height - insets))
        }

        path.addLine(to: CGPoint(x: size.width - insets, y: size.height - radius))

        path.addArc(
            center: CGPoint(x: size.width - radius, y: size.height - radius),
            radius: arcRadius,
            startAngle: .zero,
            endAngle: .pi * 0.5,
            clockwise: false
        )
    }

    private func addBottomLeftArc(
        to path: CGMutablePath,
        corners: CornersValue,
        size: CGSize,
        insets: CGFloat
    ) {
        let maxRadius = 0.5 * min(size.width, size.height)
        let radius = min(corners.bottomLeft, maxRadius)
        let arcRadius = radius - insets

        guard radius > .leastNonzeroMagnitude, arcRadius > .leastNonzeroMagnitude else {
            return path.addLine(to: CGPoint(x: insets, y: size.height - insets))
        }

        path.addLine(to: CGPoint(x: radius, y: size.height - insets))

        path.addArc(
            center: CGPoint(x: radius, y: size.height - radius),
            radius: arcRadius,
            startAngle: .pi * 0.5,
            endAngle: .pi,
            clockwise: false
        )
    }

    private func rectangularPath(size: CGSize, insets: CGFloat) -> CGPath {
        let rect = CGRect(origin: .zero, size: size).insetBy(
            dx: insets,
            dy: insets
        )

        return CGPath(rect: rect, transform: nil)
    }
}

extension RectangleShape: ShapeValue {

    public var animatableData: RectangleAnimatableData {
        get {
            RectangleAnimatableData(
                topLeft: corners.topLeft,
                topRight: corners.topRight,
                bottomLeft: corners.bottomLeft,
                bottomRight: corners.bottomRight
            )
        }

        set {
            corners.topLeft = newValue.topLeft
            corners.topRight = newValue.topRight
            corners.bottomLeft = newValue.bottomLeft
            corners.bottomRight = newValue.bottomRight
        }
    }

    public func path(size: CGSize, insets: CGFloat) -> CGPath {
        guard corners != .rectangular else {
            return rectangularPath(size: size, insets: insets)
        }

        let path = CGMutablePath()

        path.move(to: CGPoint(x: insets, y: 0.5 * size.height))

        addTopLeftArc(to: path, corners: corners, size: size, insets: insets)
        addTopRightArc(to: path, corners: corners, size: size, insets: insets)
        addBottomRightArc(to: path, corners: corners, size: size, insets: insets)
        addBottomLeftArc(to: path, corners: corners, size: size, insets: insets)

        path.closeSubpath()

        return path
    }
}

extension AnyShapeValue {

    public static let rectangle = rectangle(corners: .rectangular)

    public static func rectangle(corners: CornersValue) -> Self {
        Self(RectangleShape(corners: corners))
    }
}

extension ShapeToken {

    public static let rectangle = rectangle(corners: .rectangular)

    public static func rectangle(corners: CornersToken) -> Self {
        ShapeToken(traits: [corners]) { theme in
            .rectangle(corners: corners.resolve(for: theme))
        }
    }

    public static func rounded(
        radius: CornerRadiusToken,
        mask: CornersMask = .all
    ) -> Self {
        rectangle(corners: CornersToken(radius: radius, mask: mask))
    }
}
