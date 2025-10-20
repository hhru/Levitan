import Foundation

internal final class ObjectAssociation<Value>: @unchecked Sendable {

    private let policy: objc_AssociationPolicy
    private let queue = DispatchQueue(
        label: "object_association_queue",
        attributes: .concurrent
    )

    internal init(policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        self.policy = policy
    }

    internal subscript(object: AnyObject) -> Value? {
        get {
            queue.sync {
                objc_getAssociatedObject(
                    object,
                    Unmanaged.passRetained(self).toOpaque()
                ) as? Value
            }
        }

        set {
            nonisolated(unsafe) let unsafeObject = object
            nonisolated(unsafe) let unsafeNewValue = newValue

            queue.async(flags: .barrier) { [weak self] in
                guard let self else {
                    return
                }

                objc_setAssociatedObject(
                    unsafeObject,
                    Unmanaged.passRetained(self).toOpaque(),
                    unsafeNewValue,
                    policy
                )
            }
        }
    }
}
