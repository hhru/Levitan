#if canImport(UIKit)
import Foundation

@dynamicMemberLookup
public struct TokenViewPropertySubscript<Value, Details: Hashable> {

    internal let property: TokenViewProperty<Value, Details>
    internal let keyPath: AnyKeyPath
    internal let view: AnyTokenView

    private func propertyBinding(detailsKeyPath: KeyPath<Details, Details>) -> TokenViewPropertyBinding<Value> {
        let details = property.defaultDetails[keyPath: detailsKeyPath]
        let keyPath = property.overloadingKeyPath ?? keyPath

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

    public subscript(dynamicMember keyPath: KeyPath<Details, Details>) -> Token<Value>? {
        get { propertyBinding(detailsKeyPath: keyPath).token }
        nonmutating set { propertyBinding(detailsKeyPath: keyPath).token = newValue }
    }

    public subscript(dynamicMember keyPath: KeyPath<Details, Details>) -> Value?
    where Value: Hashable {
        get { self[dynamicMember: keyPath]?.resolve(for: view.tokenViewManager.theme) }
        nonmutating set { self[dynamicMember: keyPath] = newValue.map { .value($0) } }
    }
}
#endif
