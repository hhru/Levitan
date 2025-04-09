#if canImport(UIKit)
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

    public subscript<Value>(
        dynamicMember keyPath: PropertyPath<Value, Void>
    ) -> Token<Value>? {
        get { propertyBinding(at: keyPath).token }
        nonmutating set { propertyBinding(at: keyPath).token = newValue }
    }

    public subscript<Value: Hashable>(
        dynamicMember keyPath: PropertyPath<Value, Void>
    ) -> Value? {
        get { self[dynamicMember: keyPath]?.resolve(for: theme) }
        nonmutating set { self[dynamicMember: keyPath] = newValue.map { .value($0) } }
    }

    public subscript<Value, Details: Hashable>(
        dynamicMember keyPath: PropertyPath<Value, Details>
    ) -> Token<Value>? {
        get { propertyBinding(at: keyPath).token }
        nonmutating set { propertyBinding(at: keyPath).token = newValue }
    }

    public subscript<Value: Hashable, Details: Hashable>(
        dynamicMember keyPath: PropertyPath<Value, Details>
    ) -> Value? {
        get { self[dynamicMember: keyPath]?.resolve(for: theme) }
        nonmutating set { self[dynamicMember: keyPath] = newValue.map { .value($0) } }
    }

    public subscript<Value, Details: Hashable>(
        dynamicMember keyPath: PropertyPath<Value, Details>
    ) -> TokenViewPropertySubscript<Value, Details> {
        TokenViewPropertySubscript(
            property: viewProperties[keyPath: keyPath],
            keyPath: keyPath,
            view: view
        )
    }
}

extension TokenViewDSL {

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
}

extension AnyTokenView {

    public var tokens: TokenViewDSL<Self> {
        TokenViewDSL(view: self)
    }
}
#endif
