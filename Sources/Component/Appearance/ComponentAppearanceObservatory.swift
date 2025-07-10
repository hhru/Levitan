#if canImport(UIKit)
import Foundation

@MainActor
public final class ComponentAppearanceObservatory {

    private var observers: [ComponentAppearanceObserverStorage] = []

    public init() { }

    private func updateObservers(appending storage: ComponentAppearanceObserverStorage) {
        observers = observers
            .filter { $0.observer != nil }
            .appending(storage)
    }

    private func updateObservers(removing storage: ComponentAppearanceObserverStorage) {
        observers = observers
            .filter { $0.observer != nil }
            .filter { $0 !== storage }
    }

    public func observe(by observer: ComponentAppearanceObserver) -> ComponentAppearanceObserverToken {
        let storage = ComponentAppearanceObserverStorage(observer: observer)

        updateObservers(appending: storage)

        return ComponentAppearanceObserverToken { [weak self, weak storage] in
            if let storage {
                self?.updateObservers(removing: storage)
            }
        }
    }

    public func notify(_ body: (_ observer: ComponentAppearanceObserver) throws -> Void) rethrows {
        try observers
            .compactMap { $0.observer }
            .forEach(body)
    }
}
#endif
