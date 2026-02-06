import SwiftUI

public struct TokenModifiedView<Modifier: TokenViewModifier> {

    public let content: Modifier.Content
    public let modifier: Modifier

    @ViewEnvironment(\.tokenTheme)
    private var theme: TokenTheme

    public init(
        content: Modifier.Content,
        modifier: Modifier
    ) {
        self.content = content
        self.modifier = modifier
    }
}

extension TokenModifiedView: Equatable where
    Modifier.Content: Equatable,
    Modifier: Equatable { }

extension TokenModifiedView: Hashable where
    Modifier.Content: Hashable,
    Modifier: Hashable { }

extension TokenModifiedView: Sendable where
    Modifier.Content: Sendable,
    Modifier: Sendable { }

extension TokenModifiedView: View {

    public var body: Modifier.Body {
        modifier.body(
            content: content,
            theme: theme
        )
    }
}
