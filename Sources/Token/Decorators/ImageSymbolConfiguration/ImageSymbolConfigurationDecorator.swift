import Foundation

internal struct ImageSymbolConfigurationDecorator<Value: DecorableByImageSymbolConfiguration>: TokenDecorator {

    internal let symbolConfiguration: ImageSymbolConfiguration?

    internal func decorate(_ value: Value, theme: TokenTheme) -> Value {
        value.symbolConfiguration(symbolConfiguration)
    }
}

extension Token where Value: DecorableByImageSymbolConfiguration {

    public func symbolConfiguration(_ symbolConfiguration: ImageSymbolConfiguration?) -> Self {
        decorated(by: ImageSymbolConfigurationDecorator(symbolConfiguration: symbolConfiguration))
    }
}
