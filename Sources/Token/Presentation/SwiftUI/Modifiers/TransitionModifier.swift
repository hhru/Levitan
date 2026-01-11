import SwiftUI

public struct TransitionModifier<Content: View> {

    public let transition: AnyTransition
    public let animation: AnimationToken?

    public init(
        transition: AnyTransition,
        animation: AnimationToken?
    ) {
        self.transition = transition
        self.animation = animation
    }
}

extension TransitionModifier: TokenViewModifier {

    public func body(content: Content, theme: TokenTheme) -> some View {
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
    ) -> TokenModifiedView<TransitionModifier<Self>> {
        modifier(
            TransitionModifier(
                transition: transition,
                animation: animation
            )
        )
    }
}
