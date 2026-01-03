import SwiftUI

internal struct SpringAnimationModifier<Content: View, Value: Equatable>:
    TokenViewModifier,
    Equatable {

    internal let animation: SpringAnimationToken?
    internal let value: Value

    internal func body(content: Content, theme: TokenTheme) -> some View {
        content.animation(
            animation?.animation.resolve(for: theme),
            value: value
        )
    }
}

extension SpringAnimationModifier: Sendable where Value: Sendable { }

extension View {

    public nonisolated func springAnimation<Value: Equatable>(
        _ animation: SpringAnimationToken?,
        value: Value
    ) -> some View {
        modifier(
            SpringAnimationModifier(
                animation: animation,
                value: value
            )
        )
    }
}
