import Foundation

final class ObjectAssociation<Value>: @unchecked Sendable {

    let policy: objc_AssociationPolicy

    init(policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        self.policy = policy
    }

    subscript(object: AnyObject) -> Value? {
        get {
            objc_getAssociatedObject(
                object,
                Unmanaged.passUnretained(self).toOpaque()
            ) as? Value
        }

        set {
            objc_setAssociatedObject(
                object,
                Unmanaged.passUnretained(self).toOpaque(),
                newValue,
                policy
            )
        }
    }
}
