import SwiftUI

public struct TokenModifiedView<Modifier: TokenViewModifier> {

    public typealias Content = Modifier.Content
    public typealias Body = Modifier.Body

    public let content: Content
    public let modifier: Modifier

    @Environment(\.tokenTheme)
    private var theme: TokenTheme

    public init(
        content: Content,
        modifier: Modifier
    ) {
        self.content = content
        self.modifier = modifier
    }
}

extension TokenModifiedView: View {

    public var body: Body {
        modifier.body(
            content: content,
            theme: theme
        )
    }
}
