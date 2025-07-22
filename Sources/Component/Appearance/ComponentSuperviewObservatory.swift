#if canImport(UIKit)
import Foundation

@MainActor
public final class ComponentSuperviewObservatory {

    private var observers: [ComponentSuperviewObserverStorage] = []

    public init() { }

    private func updateObservers(appending storage: ComponentSuperviewObserverStorage) {
        observers = observers
            .filter { $0.observer != nil }
            .appending(storage)
    }

    private func updateObservers(removing storage: ComponentSuperviewObserverStorage) {
        observers = observers
            .filter { $0.observer != nil }
            .filter { $0 !== storage }
    }

    public func observe(by observer: ComponentSuperviewObserver) -> ComponentSuperviewObserverToken {
        let storage = ComponentSuperviewObserverStorage(observer: observer)

        updateObservers(appending: storage)

        return ComponentSuperviewObserverToken { [weak self, weak storage] in
            if let storage {
                self?.updateObservers(removing: storage)
            }
        }
    }

    public func notify(_ body: (_ observer: ComponentSuperviewObserver) throws -> Void) rethrows {
        try observers
            .compactMap { $0.observer }
            .forEach(body)
    }
}
#endif
