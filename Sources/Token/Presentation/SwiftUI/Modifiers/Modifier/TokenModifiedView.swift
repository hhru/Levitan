import SwiftUI

public struct TokenModifiedView<Modifier: TokenViewModifier> {

    public typealias Content = Modifier.Content
    public typealias Body = Modifier.Body

    public let content: Content
    public let modifier: Modifier

    @ViewEnvironment(\.tokenTheme)
    private var theme: TokenTheme

    public init(
        content: Content,
        modifier: Modifier
    ) {
        self.content = content
        self.modifier = modifier
    }
}

extension TokenModifiedView: Equatable where
    Content: Equatable,
    Modifier: Equatable { }

extension TokenModifiedView: Hashable where
    Content: Hashable,
    Modifier: Hashable { }

extension TokenModifiedView: Sendable where
    Content: Sendable,
    Modifier: Sendable { }

extension TokenModifiedView: View {

    public var body: Body {
        modifier.body(
            content: content,
            theme: theme
        )
    }
}
