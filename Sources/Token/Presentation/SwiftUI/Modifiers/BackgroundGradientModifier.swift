import SwiftUI

public struct BackgroundGradientModifier<Content: View>: Hashable, Sendable {

    public let gradient: GradientToken?

    public init(gradient: GradientToken?) {
        self.gradient = gradient
    }
}

extension BackgroundGradientModifier: TokenViewModifier {

    public func body(content: Content, theme: TokenTheme) -> some View {
        if let gradient = gradient?.linearGradient.resolve(for: theme) {
            content.background(gradient)
        } else {
            content
        }
    }
}

extension View {

    public nonisolated func backgroundGradient(
        _ gradient: GradientToken?
    ) -> TokenModifiedView<BackgroundGradientModifier<Self>> {
        modifier(BackgroundGradientModifier(gradient: gradient))
    }
}
