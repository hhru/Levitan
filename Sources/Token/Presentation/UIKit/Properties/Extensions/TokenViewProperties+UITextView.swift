#if canImport(UIKit1)
import UIKit

extension TokenViewProperties where View: UITextView {

    public var textColor: TokenViewProperty<ColorValue, Void> {
        property { view, value in
            view.textColor = value?.uiColor
        }
    }

    public var textFont: TokenViewProperty<FontValue, Void> {
        property { view, value in
            view.font = value?.uiFont
        }
    }

    public var textContainerInset: TokenViewProperty<InsetsValue, Void> {
        property { view, value in
            view.textContainerInset = value?.uiEdgeInsets ?? UIEdgeInsets(
                top: 8.0,
                left: .zero,
                bottom: 8.0,
                right: .zero
            )
        }
    }

    public var typingAttributes: TokenViewProperty<TypographyValue, Void> {
        property { view, value in
            view.typingAttributes = value?.attributes ?? [:]
        }
    }

// TODO: implement for text
//    public var text: TokenViewProperty<TokenText, Void> {
//        property { view, value, theme in
//            view.attributedText = value?.nsAttributedString(for: theme)
//        }
//    }
}
#endif
