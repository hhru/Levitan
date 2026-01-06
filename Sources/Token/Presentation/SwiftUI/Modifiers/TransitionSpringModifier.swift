import SwiftUI

public struct TransitionSpringModifier<Content: View> {

    public let transition: AnyTransition
    public let animation: SpringAnimationToken?

    public init(
        transition: AnyTransition,
        animation: SpringAnimationToken?
    ) {
        self.transition = transition
        self.animation = animation
    }
}

extension TransitionSpringModifier: TokenViewModifier {

    public func body(content: Content, theme: TokenTheme) -> some View {
        if let animation = animation?.resolve(for: theme) {
            content.transition(transition.animation(animation.animation))
        } else {
            content.transition(transition)
        }
    }
}

extension View {

    public nonisolated func transitionSpring(
        _ transition: AnyTransition,
        animation: SpringAnimationToken?
    ) -> TokenModifiedView<TransitionSpringModifier<Self>> {
        modifier(
            TransitionSpringModifier(
                transition: transition,
                animation: animation
            )
        )
    }
}
