#if canImport(UIKit1)
import QuartzCore

internal final class MaskLayer: CAShapeLayer {

    internal var shape: ShapeValue = .rectangle {
        didSet {
            if shape != oldValue {
                updatePathIfPossible()
            }
        }
    }

    internal override init() {
        super.init()
    }

    internal override init(layer: Any) {
        if let layer = layer as? Self {
            shape = layer.shape
        } else {
            shape = .rectangle
        }

        super.init(layer: layer)
    }

    @available(*, unavailable)
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updatePathIfPossible() {
        guard !bounds.isEmpty else {
            return
        }

        path = shape.path(size: bounds.size)
    }

    internal override func layoutSublayers() {
        super.layoutSublayers()

        updatePathIfPossible()
    }
}
#endif
