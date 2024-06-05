import Foundation

public protocol Changeable {

    associatedtype ChangeableCopy

    var changeableCopy: ChangeableCopy { get }

    init(copy: ChangeableCopy)
}

extension Changeable where ChangeableCopy == Self {

    public var changeableCopy: ChangeableCopy { self }

    public init(copy: ChangeableCopy) {
        self = copy
    }
}

extension Changeable where ChangeableCopy == ChangeableWrapper<Self> {

    public func changing<T>(_ keypath: KeyPath<Self, T>, to value: T) -> Self {
        Self(copy: ChangeableWrapper(wrapped: self, changes: [keypath: value]))
    }
}

extension Changeable {

    public func changing(_ change: (inout ChangeableCopy) -> Void) -> Self {
        var copy = self.changeableCopy

        change(&copy)

        return Self(copy: copy)
    }
}
