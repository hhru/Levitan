import Foundation

internal final class ObjectAssociation<Value> {

    private let policy: objc_AssociationPolicy

    internal init(policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        self.policy = policy
    }

    internal subscript(object: AnyObject) -> Value? {
        get {
            objc_getAssociatedObject(
                object,
                Unmanaged.passRetained(self).toOpaque()
            ) as? Value
        }

        set {
            objc_setAssociatedObject(
                object,
                Unmanaged.passRetained(self).toOpaque(),
                newValue,
                policy
            )
        }
    }
}
