#if canImport(UIKit)
import SwiftUI

public struct ComponentLayoutInvalidation: Equatable, Sendable {

    @ViewAction
    internal var action: @Sendable @MainActor () -> Void

    @MainActor
    public func callAsFunction() {
        action()
    }
}
#endif
