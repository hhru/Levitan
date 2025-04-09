import Foundation

public protocol Changeable {

    associatedtype ChangeableCopy = Self

    var changeableCopy: ChangeableCopy { get }

    init(copy: ChangeableCopy)
}

extension Changeable where ChangeableCopy == Self {

    public var changeableCopy: ChangeableCopy {
        self
    }

    public init(copy: ChangeableCopy) {
        self = copy
    }

    public func changing<Value>(_ keypath: WritableKeyPath<Self, Value>, to value: Value) -> Self {
        var copy = self.changeableCopy

        copy[keyPath: keypath] = value

        return Self(copy: copy)
    }
}

extension Changeable {

    public func changing(_ change: (inout ChangeableCopy) -> Void) -> Self {
        var copy = self.changeableCopy

        change(&copy)

        return Self(copy: copy)
    }
}
