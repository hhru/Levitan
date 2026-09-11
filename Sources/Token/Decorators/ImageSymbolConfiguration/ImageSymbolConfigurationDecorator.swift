import Foundation

internal struct ImageSymbolConfigurationDecorator<Value: DecorableByImageSymbolConfiguration>: TokenDecorator {

    internal let imageSymbolConfiguration: ImageSymbolConfiguration?

    internal func decorate(_ value: Value, theme: TokenTheme) -> Value {
        value
            .imageSymbolConfiguration(imageSymbolConfiguration)
    }
}

extension Token where Value: DecorableByImageSymbolConfiguration {

    public func imageSymbolConfiguration(_ imageSymbolConfiguration: ImageSymbolConfiguration?) -> Self {
        decorated(by: ImageSymbolConfigurationDecorator(imageSymbolConfiguration: imageSymbolConfiguration))
    }
}
