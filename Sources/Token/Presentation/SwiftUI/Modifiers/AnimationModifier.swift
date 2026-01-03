import SwiftUI

internal struct AnimationModifier<Content: View, Value: Equatable>:
    TokenViewModifier,
    Equatable {

    internal let animation: AnimationToken?
    internal let value: Value

    internal func body(content: Content, theme: TokenTheme) -> some View {
        content.animation(
            animation?.animation.resolve(for: theme),
            value: value
        )
    }
}

extension AnimationModifier: Sendable where Value: Sendable { }

extension View {

    public nonisolated func animation<Value: Equatable>(
        _ animation: AnimationToken?,
        value: Value
    ) -> some View {
        modifier(
            AnimationModifier(
                animation: animation,
                value: value
            )
        )
    }
}
