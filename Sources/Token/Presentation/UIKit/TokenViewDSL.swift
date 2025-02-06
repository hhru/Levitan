#if canImport(UIKit1)
import Foundation

@dynamicMemberLookup
public struct TokenViewDSL<View: AnyTokenView> {

    public typealias PropertyPath<Value, Details> = KeyPath<
        TokenViewProperties<View>,
        TokenViewProperty<Value, Details>
    >

    internal let view: View
    internal let viewProperties = TokenViewProperties<View>()

    public var theme: TokenTheme {
        view.tokenViewManager.theme
    }

    public var themeManager: TokenThemeManager? {
        view.tokenViewManager.themeManager
    }

    public func themeKey(_ themeKey: TokenThemeKey?) {
        view.tokenViewManager.themeKey(themeKey)
    }

    public func themeScheme(_ themeScheme: TokenThemeScheme?) {
        view.tokenViewManager.themeScheme(themeScheme)
    }

    public func themeManager(_ themeManager: TokenThemeManager?) {
        view.tokenViewManager.themeManager(themeManager)
    }

    @discardableResult
    public func customBinding(
        handler: @escaping (
            _ view: View,
            _ theme: TokenTheme
        ) -> Void
    ) -> TokenViewCustomBinding {
        view.tokenViewManager.customBinding(handler: handler)
    }

    private func propertyBinding<Value>(
        at keyPath: PropertyPath<Value, Void>
    ) -> TokenViewPropertyBinding<Value> {
        let property = viewProperties[keyPath: keyPath]
        let keyPath = property.overloadingKeyPath ?? keyPath

        return view
            .tokenViewManager
            .propertyBinding(at: keyPath) { view, value, theme in
                property.handler(view, value, Void(), theme)
            }
    }

    private func propertyBinding<Value, Details: Hashable>(
        at keyPath: PropertyPath<Value, Details>
    ) -> TokenViewPropertyBinding<Value> {
        let property = viewProperties[keyPath: keyPath]

        let keyPath = property.overloadingKeyPath ?? keyPath
        let details = property.defaultDetails

        let propertyKey = TokenViewPropertyKey(
            keyPath: keyPath,
            details: details
        )

        return view
            .tokenViewManager
            .propertyBinding(at: propertyKey) { view, value, theme in
                property.handler(view, value, details, theme)
            }
    }

    private func propertySubscript<Value, Details: Hashable>(
        at keyPath: PropertyPath<Value, Details>
    ) -> TokenViewPropertySubscript<Value, Details> {
        let property = viewProperties[keyPath: keyPath]

        return TokenViewPropertySubscript(
            defaultDetails: property.defaultDetails
        ) { [weak view] details in
            let keyPath = property.overloadingKeyPath ?? keyPath

            let propertyKey = TokenViewPropertyKey(
                keyPath: keyPath,
                details: details
            )

            return view?
                .tokenViewManager
                .propertyBinding(at: propertyKey) { view, value, theme in
                    property.handler(view, value, details, theme)
                }
        }
    }

    public subscript<Value>(
        dynamicMember keyPath: PropertyPath<Value, Void>
    ) -> Token<Value>? {
        get { propertyBinding(at: keyPath).token }
        nonmutating set { propertyBinding(at: keyPath).token = newValue }
    }

    public subscript<Value, Details: Hashable>(
        dynamicMember keyPath: PropertyPath<Value, Details>
    ) -> Token<Value>? {
        get { propertyBinding(at: keyPath).token }
        nonmutating set { propertyBinding(at: keyPath).token = newValue }
    }

    public subscript<Value, Details: Hashable>(
        dynamicMember keyPath: PropertyPath<Value, Details>
    ) -> TokenViewPropertySubscript<Value, Details> {
        propertySubscript(at: keyPath)
    }
}

extension AnyTokenView {

    public var tokens: TokenViewDSL<Self> {
        TokenViewDSL(view: self)
    }
}
#endif
