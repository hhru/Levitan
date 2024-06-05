import QuartzCore

internal final class FrontLayer: CALayer {

    internal var shape: ShapeValue = .rectangle {
        didSet {
            updateShadowLayers()
            updateStrokeLayer()
        }
    }

    internal var shadows: [ShadowValue] = [] {
        didSet { updateShadowLayers() }
    }

    internal var stroke: StrokeValue? {
        didSet {
            updateStrokeLayer()
            updateShadowLayers()
        }
    }

    private var shadowLayers: [ShadowLayer] = []
    private var strokeLayer: StrokeLayer?

    internal override init() {
        super.init()
    }

    internal override init(layer: Any) {
        if let layer = layer as? Self {
            shape = layer.shape
            shadows = layer.shadows
            stroke = layer.stroke
        } else {
            shape = .rectangle
            shadows = []
            stroke = nil
        }

        super.init(layer: layer)
    }

    @available(*, unavailable)
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Shadows

    private func setupShadowLayer(shadow: ShadowValue) -> ShadowLayer {
        let shadowLayer = ShadowLayer(
            shadow: shadow,
            stroke: stroke,
            shape: shape
        )

        if let strokeLayer {
            insertSublayer(shadowLayer, below: strokeLayer)
        } else {
            addSublayer(shadowLayer)
        }

        shadowLayer.frame = bounds

        return shadowLayer
    }

    private func resetShadowLayer(_ shadowLayer: ShadowLayer) {
        shadowLayer.removeFromSuperlayer()
    }

    private func updateShadowLayers() {
        for index in shadows.indices {
            let shadow = shadows[index]

            if index < shadowLayers.count {
                let shadowLayer = shadowLayers[index]

                shadowLayer.shadow = shadow
                shadowLayer.stroke = stroke
                shadowLayer.shape = shape
            } else {
                let shadowLayer = setupShadowLayer(shadow: shadow)

                shadowLayers.append(shadowLayer)
            }
        }

        while shadows.count < shadowLayers.count {
            resetShadowLayer(shadowLayers.removeLast())
        }
    }

    // MARK: - Stroke

    private func setupStrokeLayer(stroke: StrokeValue) {
        let strokeLayer = StrokeLayer(
            stroke: stroke,
            shape: shape
        )

        self.strokeLayer = strokeLayer

        addSublayer(strokeLayer)

        strokeLayer.frame = bounds
    }

    private func resetStrokeLayer() {
        strokeLayer?.removeFromSuperlayer()
        strokeLayer = nil
    }

    private func updateStrokeLayer() {
        guard let stroke else {
            return resetStrokeLayer()
        }

        guard let strokeLayer else {
            return setupStrokeLayer(stroke: stroke)
        }

        strokeLayer.stroke = stroke
        strokeLayer.shape = shape
    }

    // MARK: -

    internal override func layoutSublayers() {
        super.layoutSublayers()

        for shadowLayer in shadowLayers {
            shadowLayer.frame = bounds
        }

        strokeLayer?.frame = bounds
    }
}
