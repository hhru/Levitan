#if canImport(UIKit)
import UIKit

extension TokenViewProperties where View: UITextField {

    public var defaultTextAttributes: TokenViewProperty<TypographyValue, Void> {
        property { view, value in
            view.defaultTextAttributes = value?.attributes ?? [:]
        }
    }

    public var typingAttributes: TokenViewProperty<TypographyValue, Void> {
        property { view, value in
            view.typingAttributes = value?.attributes ?? [:]
        }
    }

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

    public var backgroundImage: TokenViewProperty<ImageValue, Void> {
        property { view, value in
            view.background = value?.uiImage
        }
    }

    public var disabledBackgroundImage: TokenViewProperty<ImageValue, Void> {
        property { view, value in
            view.disabledBackground = value?.uiImage
        }
    }
}
#endif
