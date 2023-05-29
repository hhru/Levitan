import Foundation

public protocol TokenDecorator: Hashable, Sendable {

    associatedtype Input
    associatedtype Output

    func decorate(_ value: Input, theme: TokenTheme) -> Output
}

extension Token {

    public func decorated<Decorator: TokenDecorator>(
        by decorator: Decorator
    ) -> Token<Decorator.Output> where Decorator.Input == Value {
        Token<Decorator.Output>(traits: traits.appending(TokenTrait(decorator))) { theme in
            decorator.decorate(resolve(for: theme), theme: theme)
        }
    }
}
