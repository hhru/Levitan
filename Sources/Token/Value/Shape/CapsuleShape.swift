import CoreGraphics
import Foundation

public struct CapsuleShape: CustomShape, Hashable {

    private func addTopLeftArc(to path: CGMutablePath, radius: CGFloat, size: CGSize) {
        guard radius > .leastNonzeroMagnitude else {
            return path.addLine(to: .zero)
        }

        path.addLine(to: CGPoint(x: .zero, y: radius))

        path.addArc(
            center: CGPoint(x: radius, y: radius),
            radius: radius,
            startAngle: .pi,
            endAngle: .pi * 1.5,
            clockwise: false
        )
    }

    private func addTopRightArc(to path: CGMutablePath, radius: CGFloat, size: CGSize) {
        guard radius > .leastNonzeroMagnitude else {
            return path.addLine(to: CGPoint(x: size.width, y: .zero))
        }

        path.addLine(to: CGPoint(x: size.width - radius, y: .zero))

        path.addArc(
            center: CGPoint(x: size.width - radius, y: radius),
            radius: radius,
            startAngle: .pi * 1.5,
            endAngle: .pi * 2.0,
            clockwise: false
        )
    }

    private func addBottomRightArc(to path: CGMutablePath, radius: CGFloat, size: CGSize) {
        guard radius > .leastNonzeroMagnitude else {
            return path.addLine(to: CGPoint(x: size.width, y: size.height))
        }

        path.addLine(to: CGPoint(x: size.width, y: size.height - radius))

        path.addArc(
            center: CGPoint(x: size.width - radius, y: size.height - radius),
            radius: radius,
            startAngle: .zero,
            endAngle: .pi * 0.5,
            clockwise: false
        )
    }

    private func addBottomLeftArc(to path: CGMutablePath, radius: CGFloat, size: CGSize) {
        guard radius > .leastNonzeroMagnitude else {
            return path.addLine(to: CGPoint(x: .zero, y: size.height))
        }

        path.addLine(to: CGPoint(x: radius, y: size.height))

        path.addArc(
            center: CGPoint(x: radius, y: size.height - radius),
            radius: radius,
            startAngle: .pi * 0.5,
            endAngle: .pi,
            clockwise: false
        )
    }

    public func path(size: CGSize, insets: CGFloat) -> CGPath {
        let path = CGMutablePath()

        let size = CGSize(
            width: max(size.width - 2.0 * insets, .zero),
            height: max(size.height - 2.0 * insets, .zero)
        )

        let radius = 0.5 * min(size.width, size.height)

        path.move(to: CGPoint(x: .zero, y: 0.5 * size.height))

        addTopLeftArc(to: path, radius: radius, size: size)
        addTopRightArc(to: path, radius: radius, size: size)
        addBottomRightArc(to: path, radius: radius, size: size)
        addBottomLeftArc(to: path, radius: radius, size: size)

        path.closeSubpath()

        var translation = CGAffineTransform(
            translationX: insets,
            y: insets
        )

        return path.copy(using: &translation) ?? path
    }
}

extension ShapeValue {

    public static let capsule = Self.custom(CapsuleShape())
}

extension ShapeToken {

    public static var capsule: Self {
        .custom(.value(CapsuleShape()))
    }
}
