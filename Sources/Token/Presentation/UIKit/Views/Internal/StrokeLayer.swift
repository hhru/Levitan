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

    private func updatePathIfPossible() {
        guard !bounds.isEmpty else {
            return
        }

        let insets = stroke.insets
        let externalPath = shapePath(insets: insets)

        path = externalPath
    }

    private func updateStroke() {
        fillColor = UIColor.clear.cgColor
        strokeColor = stroke.color?.cgColor
        lineWidth = stroke.width
        lineCap = stroke.style.caLineCap
        lineJoin = stroke.style.caLineJoin
        miterLimit = stroke.style.miterLimit
        lineDashPhase = stroke.style.dashPhase
        lineDashPattern = stroke.style.dash.map { NSNumber(value: $0) }

        updatePathIfPossible()
    }

    internal override func layoutSublayers() {
        super.layoutSublayers()

        updatePathIfPossible()
    }
}
#endif
