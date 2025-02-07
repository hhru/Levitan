#if canImport(UIKit)
import UIKit

extension TokenViewProperties where View: UITextView {

    public var text: TokenViewProperty<Text, Void> {
        property { view, value, theme in
            let context = ComponentContext
                .default
                .tokenThemeKey(theme.key)
                .tokenThemeScheme(theme.scheme)

            view.attributedText = value?.attributedText(context: context)

            view.textContainer.maximumNumberOfLines = value?.lineLimit ?? .zero
            view.textContainer.lineBreakMode = value?.lineBreakMode ?? .byWordWrapping
        }
    }
}
#endif
