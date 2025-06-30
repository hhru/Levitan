import SwiftUI

internal struct InterpolatingSpringAnimationModifier<Content: View, Value: Equatable>: TokenViewModifier {

    internal let animation: InterpolatingSpringAnimationToken?
    internal let value: Value

    internal func body(content: Content, theme: TokenTheme) -> some View {
        content.animation(
            animation?.animation.resolve(for: theme),
            value: value
        )
    }
}

extension View {

    public func interpolatingSpringAnimation<Value: Equatable>(
        _ animation: InterpolatingSpringAnimationToken?,
        value: Value
    ) -> some View {
        modifier(
            InterpolatingSpringAnimationModifier(
                animation: animation,
                value: value
            )
        )
    }
}
