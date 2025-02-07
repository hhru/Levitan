#if canImport(UIKit)
import UIKit

extension TokenViewProperties where View: UIButton {

    public var title: TokenViewProperty<Text, ControlState> {
        property(defaultDetails: .normal) { view, value, details, theme in
            let context = ComponentContext
                .default
                .tokenThemeKey(theme.key)
                .tokenThemeScheme(theme.scheme)

            let attributedText = value?.attributedText(context: context)

            view.setAttributedTitle(
                attributedText,
                for: details.state
            )
        }
    }
}
#endif
