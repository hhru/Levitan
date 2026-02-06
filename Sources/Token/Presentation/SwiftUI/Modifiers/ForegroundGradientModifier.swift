import SwiftUI

public struct ForegroundGradientModifier<Content: View>: Hashable, Sendable {

    public let gradient: GradientToken?

    public init(gradient: GradientToken?) {
        self.gradient = gradient
    }
}

extension ForegroundGradientModifier: TokenViewModifier {

    public func body(content: Content, theme: TokenTheme) -> some View {
        if let gradient = gradient?.linearGradient.resolve(for: theme) {
            content.foregroundStyle(gradient)
        } else {
            content
        }
    }
}

extension View {

    public nonisolated func foregroundGradient(
        _ gradient: GradientToken?
    ) -> TokenModifiedView<ForegroundGradientModifier<Self>> {
        modifier(ForegroundGradientModifier(gradient: gradient))
    }
}
