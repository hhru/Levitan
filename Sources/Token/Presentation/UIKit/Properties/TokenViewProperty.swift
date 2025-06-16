#if canImport(UIKit)
import Foundation

public struct TokenViewProperty<Value, Details> {

    internal let overloadingKeyPath: AnyKeyPath?
    internal let defaultDetails: Details

    internal let handler: (
        _ view: TokenView,
        _ value: Value?,
        _ details: Details,
        _ theme: TokenTheme
    ) -> Void

    internal init<View>(
        overloadingKeyPath: AnyKeyPath?,
        defaultDetails: Details,
        handler: @escaping (
            _ view: View,
            _ value: Value?,
            _ details: Details,
            _ theme: TokenTheme
        ) -> Void
    ) {
        self.overloadingKeyPath = overloadingKeyPath
        self.defaultDetails = defaultDetails

        self.handler = { view, value, details, theme in
            guard let view = view as? View else {
                return
            }

            handler(view, value, details, theme)
        }
    }
}
#endif
