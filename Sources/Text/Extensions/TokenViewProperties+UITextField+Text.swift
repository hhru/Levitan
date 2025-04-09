#if canImport(UIKit)
import UIKit

extension TokenViewProperties where View: UITextField {

    public var placeholder: TokenViewProperty<Text, Void> {
        property { view, value, theme in
            let context = ComponentContext
                .default
                .tokenThemeKey(theme.key)
                .tokenThemeScheme(theme.scheme)

            view.attributedPlaceholder = value?.attributedText(context: context)
        }
    }
}
#endif
