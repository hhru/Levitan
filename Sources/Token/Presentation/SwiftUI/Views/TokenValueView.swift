import SwiftUI

internal struct TokenValueView<Value: View>: View {

    internal let token: Token<Value>

    @Environment(\.tokenTheme)
    internal var theme: TokenTheme

    internal var body: some View {
        token.resolve(for: theme)
    }
}

extension Token: View where Value: View {

    public var body: some View {
        TokenValueView(token: self)
    }
}
