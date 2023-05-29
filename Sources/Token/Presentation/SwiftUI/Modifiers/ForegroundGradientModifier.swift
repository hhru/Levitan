import SwiftUI

@available(iOS 15.0, tvOS 15.0, *)
internal struct ForegroundGradientModifier<Content: View>: TokenViewModifier {

    internal let gradient: GradientToken?

    @ViewBuilder
    internal func body(content: Content, theme: TokenTheme) -> some View {
        if let gradient = gradient?.linearGradient.resolve(for: theme) {
            content.foregroundStyle(gradient)
        } else {
            content
        }
    }
}

extension View {

    @available(iOS 15.0, tvOS 15.0, *)
    public func foregroundGradient(_ gradient: GradientToken?) -> some View {
        modifier(ForegroundGradientModifier(gradient: gradient))
    }
}
