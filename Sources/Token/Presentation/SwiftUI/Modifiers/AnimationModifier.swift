import SwiftUI

public struct AnimationModifier<Content: View, Value: Equatable>: Equatable {

    public let animation: AnimationToken?
    public let value: Value

    public init(
        animation: AnimationToken?,
        value: Value
    ) {
        self.animation = animation
        self.value = value
    }
}

extension AnimationModifier: Hashable where Value: Hashable { }
extension AnimationModifier: Sendable where Value: Sendable { }

extension AnimationModifier: TokenViewModifier {

    public func body(content: Content, theme: TokenTheme) -> some View {
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
    ) -> TokenModifiedView<AnimationModifier<Self, Value>> {
        modifier(
            AnimationModifier(
                animation: animation,
                value: value
            )
        )
    }
}
