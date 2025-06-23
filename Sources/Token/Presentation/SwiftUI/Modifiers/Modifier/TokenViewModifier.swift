import SwiftUI

public protocol TokenViewModifier {

    associatedtype Content: View
    associatedtype Body: View

    func body(content: Content, theme: TokenTheme) -> Body
}

extension View {

    public func modifier<Modifier: TokenViewModifier>(
        _ modifier: Modifier
    ) -> TokenModifiedView<Modifier> where Modifier.Content == Self {
        TokenModifiedView(
            content: self,
            modifier: modifier
        )
    }
}
