#if canImport(UIKit1)
import Foundation

internal final class TokenViewPropertyBinding<Value>: TokenViewBinding {

    private let handler: (
        _ view: TokenView,
        _ value: Value?,
        _ theme: TokenTheme
    ) -> Void

    private let trigger: () -> Void

    internal var token: Token<Value>? {
        didSet { trigger() }
    }

    internal init(
        handler: @escaping (
            _ view: TokenView,
            _ value: Value?,
            _ theme: TokenTheme
        ) -> Void,
        trigger: @escaping () -> Void
    ) {
        self.handler = handler
        self.trigger = trigger
    }

    internal func handle(view: TokenView, theme: TokenTheme) {
        handler(view, token?.resolve(for: theme), theme)
    }
}
#endif
