import SwiftUI

public struct ForegroundColorModifier<Content: View>: Hashable, Sendable {

    public let color: ColorToken?

    public init(color: ColorToken?) {
        self.color = color
    }
}

extension ForegroundColorModifier: TokenViewModifier {

    public func body(content: Content, theme: TokenTheme) -> some View {
        content.foregroundColor(color?.resolve(for: theme).color)
    }
}

extension View {

    public nonisolated func foregroundColor(
        _ color: ColorToken?
    ) -> TokenModifiedView<ForegroundColorModifier<Self>> {
        modifier(ForegroundColorModifier(color: color))
    }
}
