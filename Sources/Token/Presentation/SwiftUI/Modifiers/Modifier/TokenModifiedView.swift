import SwiftUI

public struct TokenModifiedView<Modifier: TokenViewModifier>: View {

    public typealias Content = Modifier.Content
    public typealias Body = Modifier.Body

    public let content: Content
    public let modifier: Modifier

    @Environment(\.tokenTheme)
    private var theme: TokenTheme

    public var body: Body {
        modifier.body(
            content: content,
            theme: theme
        )
    }

    public init(
        content: Content,
        modifier: Modifier
    ) {
        self.content = content
        self.modifier = modifier
    }
}
