import Foundation

#if canImport(UIKit)
internal struct AnyComponentContent: @unchecked Sendable {

    internal let wrapped: any Component
}
#endif
