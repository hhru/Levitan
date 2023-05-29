import QuartzCore

extension TokenViewProperties where View: CATextLayer {

    public var foregroundColor: TokenViewProperty<ColorValue, Void> {
        property { layer, value in
            layer.foregroundColor = value?.cgColor ?? .white
        }
    }

    public var font: TokenViewProperty<FontValue, Void> {
        property { layer, value in
            let font = value?.uiFont ?? .systemFont(ofSize: 36)

            layer.font = font
            layer.fontSize = font.pointSize
        }
    }
}
