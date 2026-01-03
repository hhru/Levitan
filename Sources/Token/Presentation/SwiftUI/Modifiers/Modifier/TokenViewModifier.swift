import SwiftUI

@MainActor
public protocol TokenViewModifier {

    associatedtype Content: View
    associatedtype Body: View

    @ViewBuilder
    func body(content: Content, theme: TokenTheme) -> Body
}

extension View {

    public nonisolated func modifier<Modifier: TokenViewModifier>(
        _ modifier: Modifier
    ) -> TokenModifiedView<Modifier> where Modifier.Content == Self {
        TokenModifiedView(
            content: self,
            modifier: modifier
        )
    }
}
