#if canImport(UIKit1)
import Foundation

internal struct TokenViewPropertyKey<Details> {

    internal let keyPath: AnyKeyPath
    internal let details: Details
}

extension TokenViewPropertyKey: Equatable where Details: Equatable { }
extension TokenViewPropertyKey: Hashable where Details: Hashable { }
#endif
