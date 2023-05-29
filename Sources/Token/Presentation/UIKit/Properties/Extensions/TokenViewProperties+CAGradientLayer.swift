import QuartzCore

extension TokenViewProperties where View: CAGradientLayer {

    public var gradient: TokenViewProperty<GradientValue, Void> {
        property { layer, value in
            layer.colors = value?.colors.map { $0.cgColor }
            layer.locations = value?.locations.map { $0 as [NSNumber] }
            layer.startPoint = value?.startPoint ?? CGPoint(x: 0.5, y: 0.0)
            layer.endPoint = value?.endPoint ?? CGPoint(x: 0.5, y: 1.0)
        }
    }
}
