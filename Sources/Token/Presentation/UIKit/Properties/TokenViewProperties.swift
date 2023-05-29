import Foundation

public struct TokenViewProperties<View: AnyTokenView> {

    public func property<Value, Details: Hashable>(
        overloading keyPath: PartialKeyPath<Self>? = nil,
        defaultDetails: Details,
        using handler: @escaping (
            _ view: View,
            _ value: Value?,
            _ details: Details,
            _ theme: TokenTheme
        ) -> Void
    ) -> TokenViewProperty<Value, Details> {
        TokenViewProperty(
            overloadingKeyPath: keyPath,
            defaultDetails: defaultDetails,
            handler: handler
        )
    }

    public func property<Value, Details: Hashable>(
        overloading keyPath: PartialKeyPath<Self>? = nil,
        defaultDetails: Details,
        using handler: @escaping (
            _ view: View,
            _ value: Value?,
            _ details: Details
        ) -> Void
    ) -> TokenViewProperty<Value, Details> {
        property(
            overloading: keyPath,
            defaultDetails: defaultDetails
        ) { view, value, details, _ in
            handler(view, value, details)
        }
    }

    public func property<Value>(
        overloading keyPath: PartialKeyPath<Self>? = nil,
        using handler: @escaping (
            _ view: View,
            _ value: Value?,
            _ theme: TokenTheme
        ) -> Void
    ) -> TokenViewProperty<Value, Void> {
        TokenViewProperty(
            overloadingKeyPath: keyPath,
            defaultDetails: Void()
        ) { view, value, _, theme in
            handler(view, value, theme)
        }
    }

    public func property<Value>(
        overloading keyPath: PartialKeyPath<Self>? = nil,
        using handler: @escaping (
            _ view: View,
            _ value: Value?
        ) -> Void
    ) -> TokenViewProperty<Value, Void> {
        property(overloading: keyPath) { view, value, _ in
            handler(view, value)
        }
    }
}
