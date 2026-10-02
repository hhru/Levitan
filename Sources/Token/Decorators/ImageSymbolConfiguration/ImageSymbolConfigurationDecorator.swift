import Foundation

internal struct ImageSymbolConfigurationDecorator<Value: DecorableByImageSymbolConfiguration>: TokenDecorator {

    internal let symbolConfiguration: ImageSymbolConfiguration?

    internal func decorate(_ value: Value, theme: TokenTheme) -> Value {
        value.imageSymbolConfiguration(symbolConfiguration)
    }
}

extension Token where Value: DecorableByImageSymbolConfiguration {

    public func imageSymbolConfiguration(_ symbolConfiguration: ImageSymbolConfiguration?) -> Self {
        decorated(by: ImageSymbolConfigurationDecorator(symbolConfiguration: symbolConfiguration))
    }
}
