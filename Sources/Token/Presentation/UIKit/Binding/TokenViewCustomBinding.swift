#if canImport(UIKit1)
import Foundation

public final class TokenViewCustomBinding: TokenViewBinding {

    private let handler: (
        _ view: TokenView,
        _ theme: TokenTheme
    ) -> Void

    internal init<View>(
        handler: @escaping (
            _ view: View,
            _ theme: TokenTheme
        ) -> Void
    ) {
        self.handler = { view, theme in
            guard let view = view as? View else {
                return
            }

            handler(view, theme)
        }
    }

    internal func handle(view: TokenView, theme: TokenTheme) {
        handler(view, theme)
    }
}
#endif
