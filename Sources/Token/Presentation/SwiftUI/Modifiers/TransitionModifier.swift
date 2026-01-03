import SwiftUI

internal struct TransitionModifier<Content: View> {

    internal let transition: AnyTransition
    internal let animation: AnimationToken?
}

extension TransitionModifier: TokenViewModifier {

    internal func body(content: Content, theme: TokenTheme) -> some View {
        if let animation = animation?.resolve(for: theme) {
            content.transition(transition.animation(animation.animation))
        } else {
            content.transition(transition)
        }
    }
}

extension View {

    public nonisolated func transition(
        _ transition: AnyTransition,
        animation: AnimationToken?
    ) -> some View {
        modifier(
            TransitionModifier(
                transition: transition,
                animation: animation
            )
        )
    }
}
