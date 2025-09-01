#if canImport(UIKit)
import UIKit

internal final class StrokeLayer: CAShapeLayer {

    internal var stroke: StrokeValue {
        didSet {
            if stroke != oldValue {
                updateStroke()
            }
        }
    }

    internal var shape: ShapeValue {
        didSet {
            if shape != oldValue {
                updatePathIfPossible()
            }
        }
    }

    internal init(
        stroke: StrokeValue,
        shape: ShapeValue
    ) {
        self.stroke = stroke
        self.shape = shape

        super.init()

        updateStroke()
    }

    internal override init(layer: Any) {
        if let layer = layer as? Self {
            stroke = layer.stroke
            shape = layer.shape
        } else {
            stroke = .zero
            shape = .rectangle
        }

        super.init(layer: layer)
    }

    @available(*, unavailable)
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func shapePath(insets: CGFloat) -> CGPath {
        shape.path(size: bounds.size, insets: insets)
    }

    private func setupSolidStrokeShape(insets: CGFloat) {
        let externalPath = shapePath(insets: insets)
        let internalPath = shapePath(insets: insets + stroke.width)

        if #available(iOS 16.0, tvOS 16.0, *) {
            path = externalPath.subtracting(internalPath)
        } else {
            let bezierPath = UIBezierPath()

            bezierPath.append(UIBezierPath(cgPath: externalPath))
            bezierPath.append(UIBezierPath(cgPath: internalPath).reversing())

            path = bezierPath.cgPath
        }
    }

    private func setupDashedStrokeShape(insets: CGFloat) {
        let externalPath = shapePath(insets: insets)

        path = externalPath
            .copy(dashingWithPhase: stroke.style.dashPhase, lengths: stroke.style.dash)
            .copy(
                strokingWithWidth: stroke.width,
                lineCap: stroke.style.lineCap,
                lineJoin: stroke.style.lineJoin,
                miterLimit: stroke.style.miterLimit
            )
    }

    private func updatePathIfPossible() {
        guard !bounds.isEmpty else {
            return
        }

        guard stroke.isDashed else {
            return setupSolidStrokeShape(insets: stroke.insets)
        }

        setupDashedStrokeShape(insets: stroke.insets)
    }

    private func updateStroke() {
        fillColor = stroke.color?.cgColor

        updatePathIfPossible()
    }

    internal override func layoutSublayers() {
        super.layoutSublayers()

        updatePathIfPossible()
    }
}
#endif
