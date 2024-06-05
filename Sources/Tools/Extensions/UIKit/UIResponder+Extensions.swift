import UIKit

extension UIResponder {

    internal func next<Responder: UIResponder>(of type: Responder.Type) -> Responder? {
        next.flatMap { nextResponder in
            nextResponder as? Responder
        } ?? next?.next(of: type)
    }
}
