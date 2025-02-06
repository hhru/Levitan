#if canImport(UIKit1)
import UIKit

@objc
internal protocol TraitsObservable: UITraitEnvironment {

    static var swizzleTraitCollectionDidChangeMethod: () -> Void { get }
}

private let traitsObservationAssociation = ObjectAssociation<TraitsObservation>()

extension TraitsObservable {

    internal var traitsObservation: TraitsObservation {
        if let observation = traitsObservationAssociation[self] {
            return observation
        }

        let observation = TraitsObservation()

        traitsObservationAssociation[self] = observation

        Self.swizzleTraitCollectionDidChangeMethod()

        return observation
    }

    internal func handleTraitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard traitsObservationAssociation[self] != nil else {
            return
        }

        traitsObservation.traitsDidChange(
            newTraits: traitCollection,
            previousTraits: previousTraitCollection
        )
    }
}
#endif
