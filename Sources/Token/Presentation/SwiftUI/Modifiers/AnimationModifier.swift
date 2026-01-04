import SwiftUI

internal struct AnimationModifier<Content: View, Value: Equatable>: Equatable {

    internal let animation: AnimationToken?
    internal let value: Value
}

extension AnimationModifier: Hashable where Value: Hashable { }
extension AnimationModifier: Sendable where Value: Sendable { }

extension AnimationModifier: TokenViewModifier {

    internal func body(content: Content, theme: TokenTheme) -> some View {
        content.animation(
            animation?.animation.resolve(for: theme),
            value: value
        )
    }
}

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
