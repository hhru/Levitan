import UIKit

extension TokenViewProperties where View: UIView {

    public var tintColor: TokenViewProperty<ColorValue, Void> {
        property { view, value in
            view.tintColor = value?.uiColor
        }
    }

    public var backgroundColor: TokenViewProperty<ColorValue, Void> {
        property { view, value in
            view.backgroundColor = value?.uiColor
        }
    }

    public var alpha: TokenViewProperty<CGFloat, Void> {
        property { view, value in
            view.alpha = value ?? 1.0
        }
    }

    public var scaling: TokenViewProperty<CGFloat, Void> {
        property { view, value in
            view.transform = CGAffineTransform(
                scaleX: value ?? 1.0,
                y: value ?? 1.0
            )
        }
    }

    public var shadows: TokenViewProperty<[ShadowValue], Void> {
        property { view, value in
            view.layer.updateShadows(value ?? [])
        }
    }

    public var shadow: TokenViewProperty<ShadowValue, Void> {
        property(overloading: \.shadows) { view, value in
            view.layer.updateShadows(value.map { [$0] } ?? [])
        }
    }

    public var stroke: TokenViewProperty<StrokeValue, Void> {
        property { view, value in
            view.layer.updateStroke(value)
        }
    }

    public var gradients: TokenViewProperty<[GradientValue], Void> {
        property { view, value in
            view.layer.updateGradients(value ?? [])
        }
    }

    public var gradient: TokenViewProperty<GradientValue, Void> {
        property(overloading: \.gradients) { view, value in
            view.layer.updateGradients(value.map { [$0] } ?? [])
        }
    }

    public var shapeColor: TokenViewProperty<ColorValue, Void> {
        property { view, value in
            view.layer.updateShapeColor(value)
        }
    }

    public var shape: TokenViewProperty<ShapeValue, Void> {
        property { view, value in
            view.layer.updateShape(value ?? .rectangle)
        }
    }

    public var corners: TokenViewProperty<CornersValue, Void> {
        property(overloading: \.shape) { view, value in
            view.layer.updateShape(.rectangle(corners: value ?? .rectangular))
        }
    }
}
