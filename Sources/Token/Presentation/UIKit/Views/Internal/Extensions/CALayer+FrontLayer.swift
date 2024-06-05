import QuartzCore

private let frontLayerAssociation = ObjectAssociation<FrontLayer>()

private let shadowsAssociation = ObjectAssociation<[ShadowValue]>()
private let strokeAssociation = ObjectAssociation<StrokeValue>()

extension CALayer {

    internal var frontLayer: FrontLayer? {
        frontLayerAssociation[self]
    }

    internal func setupFrontLayerIfNeeded() {
        guard frontLayer == nil else {
            return
        }

        let frontLayer = FrontLayer()

        frontLayer.name = "\(FrontLayer.self)"
        frontLayer.frame = bounds

        frontLayer.shape = maskShape
        frontLayer.shadows = shadowsAssociation[self] ?? []
        frontLayer.stroke = strokeAssociation[self]

        addSublayer(frontLayer)

        frontLayerAssociation[self] = frontLayer

        resetShadow()
        resetStroke()
    }

    internal func updateFrontLayerIfNeeded() {
        if let shadows = shadowsAssociation[self] {
            updateShadows(shadows)
        }

        if let stroke = strokeAssociation[self] {
            updateStroke(stroke)
        }
    }

    internal func resetShadow() {
        shadowColor = .black
        shadowOffset = CGSize(width: .zero, height: -3.0)
        shadowRadius = 3.0
        shadowOpacity = .zero
    }

    internal func resetStroke() {
        borderWidth = .zero
        borderColor = .black
    }

    internal func updateShadows(_ shadows: [ShadowValue]) {
        shadowsAssociation[self] = shadows

        if let frontLayer {
            frontLayer.shadows = shadows
            frontLayer.frame = bounds

            return
        }

        if shadows.count > 1 {
            return setupFrontLayerIfNeeded()
        }

        guard let shadow = shadows.first, !shadow.isClear else {
            return resetShadow()
        }

        guard shadow.type == .drop, !shadow.isSpreaded else {
            return setupFrontLayerIfNeeded()
        }

        guard maskShape == .rectangle else {
            return setupFrontLayerIfNeeded()
        }

        shadowColor = shadow.color?.alpha(1.0).cgColor ?? .black
        shadowOffset = shadow.offset
        shadowRadius = shadow.radius
        shadowOpacity = Float(shadow.color?.alpha ?? .zero)
    }

    internal func updateStroke(_ stroke: StrokeValue?) {
        strokeAssociation[self] = stroke

        if let frontLayer {
            frontLayer.stroke = stroke
            frontLayer.frame = bounds

            return
        }

        guard let stroke, !stroke.isZero else {
            return resetStroke()
        }

        guard stroke.type == .inside else {
            return setupFrontLayerIfNeeded()
        }

        guard maskShape == .rectangle else {
            return setupFrontLayerIfNeeded()
        }

        borderWidth = stroke.width
        borderColor = stroke.color?.cgColor ?? .black
    }
}
