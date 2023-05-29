import UIKit

extension TokenViewProperties where View: UILabel {

    public var textColor: TokenViewProperty<ColorValue, Void> {
        property { view, value in
            view.textColor = value?.uiColor
        }
    }

    public var highlightedTextColor: TokenViewProperty<ColorValue, Void> {
        property { view, value in
            view.highlightedTextColor = value?.uiColor
        }
    }

    public var textShadowColor: TokenViewProperty<ColorValue, Void> {
        property { view, value in
            view.shadowColor = value?.uiColor
        }
    }

    public var textShadowOffset: TokenViewProperty<CGSize, Void> {
        property { view, value in
            view.shadowOffset = value ?? CGSize(width: .zero, height: -1.0)
        }
    }

    public var textFont: TokenViewProperty<FontValue, Void> {
        property { view, value in
            view.font = value?.uiFont
        }
    }

// TODO: implement for text
//    public var text: TokenViewProperty<TokenText> {
//        property { view, value, theme in
//            let attributedString = value?.nsAttributedString(for: theme)
//
//            label.text = attributedString?.string
//            label.attributedText = attributedString
//        }
//    }
}
