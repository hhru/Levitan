import Foundation

#if canImport(UIKit)
internal struct AnyComponentContent: @unchecked Sendable {

    internal let wrapped: any Component

    internal init<Wrapped: Component>(wrapped: Wrapped) {
        self.wrapped = wrapped
    }
}
#endif
