#if canImport(UIKit)
import Foundation

@MainActor
internal final class ComponentAppearanceObserverStorage {

    internal private(set) weak var observer: ComponentAppearanceObserver?

    internal init(observer: ComponentAppearanceObserver) {
        self.observer = observer
    }
}
#endif
