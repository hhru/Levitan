#if canImport(UIKit)
import Foundation

public final class ComponentAppearanceObserverToken {

    private let cancellation: () -> Void

    internal init(cancellation: @escaping () -> Void) {
        self.cancellation = cancellation
    }

    deinit {
        cancellation()
    }

    public func cancel() {
        cancellation()
    }
}
#endif
