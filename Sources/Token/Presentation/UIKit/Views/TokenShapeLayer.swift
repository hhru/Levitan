import QuartzCore

open class TokenShapeLayer: CALayer {

    public var shape: ShapeValue = .rectangle {
        didSet { updateSublayersMask() }
    }

    public override init() {
        super.init()

        setupFrontLayerIfNeeded()
        setupBackLayerIfNeeded()
    }

    public override init(layer: Any) {
        if let layer = layer as? Self {
            shape = layer.shape
        } else {
            shape = .rectangle
        }

        super.init(layer: layer)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func resetSublayerMask(sublayer: CALayer) {
        guard sublayer.mask is MaskLayer else {
            return
        }

        sublayer.mask = nil
    }

    private func updateSublayerMask(sublayer: CALayer) {
        if let frontLayer = sublayer as? FrontLayer {
            frontLayer.shape = shape
            frontLayer.mask = nil

            return
        }

        guard shape != .rectangle else {
            return resetSublayerMask(sublayer: sublayer)
        }

        let frame = bounds.offsetBy(
            dx: -sublayer.frame.minX,
            dy: -sublayer.frame.minY
        )

        guard let maskLayer = sublayer.maskLayer else {
            return sublayer.setupMaskLayer(
                shape: shape,
                frame: frame
            )
        }

        maskLayer.shape = shape
        maskLayer.frame = frame
    }

    private func updateSublayersMask() {
        for sublayer in sublayers ?? [] {
            updateSublayerMask(sublayer: sublayer)
        }
    }

    open override func addSublayer(_ layer: CALayer) {
        super.addSublayer(layer)

        updateSublayerMask(sublayer: layer)
    }

    open override func insertSublayer(_ layer: CALayer, at index: UInt32) {
        super.insertSublayer(layer, at: index)

        updateSublayerMask(sublayer: layer)
    }

    open override func insertSublayer(_ layer: CALayer, above sublayer: CALayer?) {
        super.insertSublayer(layer, above: sublayer)

        updateSublayerMask(sublayer: layer)
    }

    open override func insertSublayer(_ layer: CALayer, below sublayer: CALayer?) {
        super.insertSublayer(layer, below: sublayer)

        updateSublayerMask(sublayer: layer)
    }

    open override func layoutSublayers() {
        super.layoutSublayers()

        updateSublayersMask()
    }
}
