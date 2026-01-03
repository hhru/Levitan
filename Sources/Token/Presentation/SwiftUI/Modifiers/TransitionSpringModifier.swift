import SwiftUI

internal struct TransitionSpringModifier<Content: View> {

    internal let transition: AnyTransition
    internal let animation: SpringAnimationToken?
}

extension TransitionSpringModifier: TokenViewModifier {

    internal func body(content: Content, theme: TokenTheme) -> some View {
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
    ) -> some View {
        modifier(
            TransitionSpringModifier(
                transition: transition,
                animation: animation
            )
        )
    }
}
