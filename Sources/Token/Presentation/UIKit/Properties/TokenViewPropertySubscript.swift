#if canImport(UIKit)
import Foundation

@dynamicMemberLookup
public struct TokenViewPropertySubscript<Value, Details: Hashable> {

    private let defaultDetails: Details
    private let bindingProvider: (_ details: Details) -> TokenViewPropertyBinding<Value>?

    internal init(
        defaultDetails: Details,
        bindingProvider: @escaping (_ details: Details) -> TokenViewPropertyBinding<Value>?
    ) {
        self.defaultDetails = defaultDetails
        self.bindingProvider = bindingProvider
    }

    public subscript(dynamicMember keyPath: KeyPath<Details, Details>) -> Token<Value>? {
        get { bindingProvider(defaultDetails[keyPath: keyPath])?.token }
        nonmutating set { bindingProvider(defaultDetails[keyPath: keyPath])?.token = newValue }
    }
}
#endif
