#if canImport(UIKit)
import Foundation

@MainActor
internal final class ComponentSuperviewObserverStorage {

    internal private(set) weak var observer: ComponentSuperviewObserver?

    internal init(observer: ComponentSuperviewObserver) {
        self.observer = observer
    }
}
#endif
