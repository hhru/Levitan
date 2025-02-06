#if canImport(UIKit)
import QuartzCore

extension TokenViewProperties where View: CALayer {

    public var opacity: TokenViewProperty<CGFloat, Void> {
        property { layer, value in
            layer.opacity = value.map(Float.init) ?? 1.0
        }
    }

    public var backgroundColor: TokenViewProperty<ColorValue, Void> {
        property { layer, value in
            layer.backgroundColor = value?.cgColor
        }
    }

    public var shadows: TokenViewProperty<[ShadowValue], Void> {
        property { layer, value in
            layer.updateShadows(value ?? [])
        }
    }

    public var shadow: TokenViewProperty<ShadowValue, Void> {
        property(overloading: \.shadows) { layer, value in
            layer.updateShadows(value.map { [$0] } ?? [])
        }
    }

    public var stroke: TokenViewProperty<StrokeValue, Void> {
        property { layer, value in
            layer.updateStroke(value)
        }
    }

    public var gradients: TokenViewProperty<[GradientValue], Void> {
        property { layer, value in
            layer.updateGradients(value ?? [])
        }
    }

    public var gradient: TokenViewProperty<GradientValue, Void> {
        property(overloading: \.gradients) { layer, value in
            layer.updateGradients(value.map { [$0] } ?? [])
        }
    }

    public var shapeColor: TokenViewProperty<ColorValue, Void> {
        property { layer, value in
            layer.updateShapeColor(value)
        }
    }

    public var shape: TokenViewProperty<ShapeValue, Void> {
        property { layer, value in
            layer.updateShape(value ?? .rectangle)
        }
    }

    public var corners: TokenViewProperty<CornersValue, Void> {
        property(overloading: \.shape) { layer, value in
            layer.updateShape(.rectangle(corners: value ?? .rectangular))
        }
    }
}
#endif
