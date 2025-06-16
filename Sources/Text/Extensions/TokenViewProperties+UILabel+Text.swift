#if canImport(UIKit)
import UIKit

extension TokenViewProperties where View: UILabel {

    public var text: TokenViewProperty<Text, Void> {
        property { view, value, theme in
            let context = ComponentContext
                .default
                .tokenThemeKey(theme.key)
                .tokenThemeScheme(theme.scheme)

            let attributedText = value?.attributedText(context: context)

            view.text = attributedText?.string
            view.attributedText = attributedText

            view.numberOfLines = value.map { $0.lineLimit ?? .zero } ?? 1
            view.lineBreakMode = value?.lineBreakMode ?? .byWordWrapping
        }
    }
}
#endif
