#if canImport(UIKit)
import QuartzCore

internal final class BackLayer: CALayer {

    internal var gradients: [GradientValue] = [] {
        didSet { updateGradientLayers() }
    }

    private var gradientLayers: [GradientLayer] = []

    internal override init() {
        super.init()
    }

    internal override init(layer: Any) {
        if let layer = layer as? Self {
            gradients = layer.gradients
        } else {
            gradients = []
        }

        super.init(layer: layer)
    }

    @available(*, unavailable)
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupGradientLayer(gradient: GradientValue) -> GradientLayer {
        let gradientLayer = GradientLayer(gradient: gradient)

        gradientLayer.masksToBounds = true
        gradientLayer.frame = bounds

        addSublayer(gradientLayer)

        return gradientLayer
    }

    private func resetGradientLayer(_ gradientLayer: GradientLayer) {
        gradientLayer.removeFromSuperlayer()
    }

    private func updateGradientLayers() {
        for index in gradients.indices {
            let gradient = gradients[index]

            if index < gradientLayers.count {
                let gradientLayer = gradientLayers[index]

                gradientLayer.gradient = gradient
            } else {
                let gradientLayer = setupGradientLayer(gradient: gradient)

                gradientLayers.append(gradientLayer)
            }
        }

        while gradients.count < gradientLayers.count {
            resetGradientLayer(gradientLayers.removeLast())
        }
    }

    internal override func layoutSublayers() {
        super.layoutSublayers()

        for gradientLayer in gradientLayers {
            gradientLayer.frame = bounds
        }
    }
}
#endif
