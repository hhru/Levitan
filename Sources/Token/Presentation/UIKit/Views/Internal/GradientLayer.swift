import QuartzCore

internal final class GradientLayer: CAGradientLayer {

    internal var gradient: GradientValue {
        didSet {
            if gradient != oldValue {
                updateGradient()
            }
        }
    }

    internal init(gradient: GradientValue) {
        self.gradient = gradient

        super.init()

        updateGradient()
    }

    internal override init(layer: Any) {
        if let layer = layer as? Self {
            gradient = layer.gradient
        } else {
            gradient = .clear
        }

        super.init(layer: layer)
    }

    @available(*, unavailable)
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateGradient() {
        colors = gradient.colors.map { $0.cgColor }
        locations = gradient.locations.map { $0 as [NSNumber] }
        startPoint = gradient.startPoint
        endPoint = gradient.endPoint
    }
}
