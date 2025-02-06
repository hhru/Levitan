#if canImport(UIKit1)
import UIKit

internal final class TraitsObservation {

    private var registry: [TraitsObserver] = []

    internal func traitsDidChange(
        newTraits: UITraitCollection,
        previousTraits: UITraitCollection?
    ) {
        registry.forEach { observer in
            observer.handle(
                newTraits: newTraits,
                previousTraits: previousTraits
            )
        }
    }

    @discardableResult
    internal func registerObserver<Observer: AnyObject>(
        _ observer: Observer,
        handler: @escaping (
            _ observer: Observer,
            _ newTraits: UITraitCollection,
            _ previousTraits: UITraitCollection?
        ) -> Void
    ) -> TraitsObserver {
        if let observer = registry.first(where: { $0.observer === observer }) {
            return observer
        }

        let observer = TraitsObserver(
            observer: observer,
            handler: handler
        )

        registry = registry
            .filter { $0.observer != nil }
            .appending(observer)

        return observer
    }

    internal func unregisterObserver(_ observer: TraitsObserver) {
        registry = registry
            .lazy
            .filter { $0.observer != nil }
            .filter { $0 !== observer }
    }
}
#endif
