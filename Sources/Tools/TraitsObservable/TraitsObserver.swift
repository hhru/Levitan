import UIKit

internal final class TraitsObserver {

    internal private(set) weak var observer: AnyObject?

    private let handler: (
        _ observer: AnyObject?,
        _ newTraits: UITraitCollection,
        _ previousTraits: UITraitCollection?
    ) -> Void

    internal init<Observer: AnyObject>(
        observer: Observer,
        handler: @escaping (
            _ observer: Observer,
            _ newTraits: UITraitCollection,
            _ previousTraits: UITraitCollection?
        ) -> Void
    ) {
        self.observer = observer

        self.handler = { observer, newTraits, previousTraits in
            guard let observer = observer as? Observer else {
                return
            }

            handler(observer, newTraits, previousTraits)
        }
    }

    internal func handle(
        newTraits: UITraitCollection,
        previousTraits: UITraitCollection?
    ) {
        handler(observer, newTraits, previousTraits)
    }
}
