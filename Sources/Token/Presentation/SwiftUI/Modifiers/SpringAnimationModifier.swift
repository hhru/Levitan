import SwiftUI

public struct SpringAnimationModifier<Content: View, Value: Equatable>: Equatable {

    public let animation: SpringAnimationToken?
    public let value: Value

    public init(
        animation: SpringAnimationToken?,
        value: Value
    ) {
        self.animation = animation
        self.value = value
    }
}

extension SpringAnimationModifier: Hashable where Value: Hashable { }
extension SpringAnimationModifier: Sendable where Value: Sendable { }

extension SpringAnimationModifier: TokenViewModifier {

    public func body(content: Content, theme: TokenTheme) -> some View {
        content.animation(
            animation?.animation.resolve(for: theme),
            value: value
        )
    }
}

extension View {

    public nonisolated func springAnimation<Value: Equatable>(
        _ animation: SpringAnimationToken?,
        value: Value
    ) -> TokenModifiedView<SpringAnimationModifier<Self, Value>> {
        modifier(
            SpringAnimationModifier(
                animation: animation,
                value: value
            )
        )
    }
}
