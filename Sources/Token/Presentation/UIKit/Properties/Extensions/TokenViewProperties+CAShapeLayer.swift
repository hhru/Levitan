#if canImport(UIKit1)
import QuartzCore

extension TokenViewProperties where View: CAShapeLayer {

    public var fillColor: TokenViewProperty<ColorValue, Void> {
        property { layer, value in
            layer.fillColor = value?.cgColor
        }
    }

    public var strokeColor: TokenViewProperty<ColorValue, Void> {
        property { layer, value in
            layer.strokeColor = value?.cgColor
        }
    }

    public var lineWidth: TokenViewProperty<CGFloat, Void> {
        property { layer, value in
            layer.lineWidth = value ?? .zero
        }
    }
}
#endif
