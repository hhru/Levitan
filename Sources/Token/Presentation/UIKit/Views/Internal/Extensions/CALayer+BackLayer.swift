#if canImport(UIKit)
import QuartzCore

private let backLayerAssociation = ObjectAssociation<BackLayer>()

private let shapeColorAssociation = ObjectAssociation<ColorValue>()
private let gradientsAssociation = ObjectAssociation<[GradientValue]>()

extension CALayer {

    internal var backLayer: BackLayer? {
        backLayerAssociation[self]
    }

    #if swift(<6.0)
    @MainActor
    #endif
    internal func setupBackLayerIfNeeded() {
        guard backLayer == nil else {
            return
        }

        let backLayer = BackLayer()

        backLayer.name = "\(BackLayer.self)"
        backLayer.frame = bounds

        backLayer.backgroundColor = shapeColorAssociation[self]?.cgColor
        backLayer.gradients = gradientsAssociation[self] ?? []

        insertSublayer(backLayer, at: .zero)

        backLayerAssociation[self] = backLayer

        resetShapeColor()
        resetGradients()
    }

    #if swift(<6.0)
    @MainActor
    #endif
    internal func updateBackLayerIfNeeded() {
        if let shapeColor = shapeColorAssociation[self] {
            updateShapeColor(shapeColor)
        }

        if let gradients = gradientsAssociation[self] {
            updateGradients(gradients)
        }
    }

    #if swift(<6.0)
    @MainActor
    #endif
    internal func resetShapeColor() {
        backgroundColor = nil
    }

    #if swift(<6.0)
    @MainActor
    #endif
    internal func resetGradients() { }

    #if swift(<6.0)
    @MainActor
    #endif
    internal func updateShapeColor(_ shapeColor: ColorValue?) {
        shapeColorAssociation[self] = shapeColor

        if let backLayer {
            backLayer.backgroundColor = shapeColor?.cgColor
            backLayer.frame = bounds

            return
        }

        guard let shapeColor, shapeColor != .clear else {
            return resetShapeColor()
        }

        guard maskShape == .rectangle else {
            return setupBackLayerIfNeeded()
        }

        backgroundColor = shapeColor.cgColor
    }

    #if swift(<6.0)
    @MainActor
    #endif
    internal func updateGradients(_ gradients: [GradientValue]) {
        gradientsAssociation[self] = gradients

        if let backLayer {
            backLayer.gradients = gradients
            backLayer.frame = bounds

            return
        }

        guard !gradients.isEmpty else {
            return resetGradients()
        }

        setupBackLayerIfNeeded()
    }
}
#endif
