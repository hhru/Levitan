import Foundation

@dynamicMemberLookup
public struct ChangeableWrapper<Wrapped> {

    private let wrapped: Wrapped
    private var changes: [AnyHashable: Any]

    internal init(
        wrapped: Wrapped,
        changes: [AnyHashable: Any]
    ) {
        self.wrapped = wrapped
        self.changes = changes
    }

    public init(_ wrapped: Wrapped) {
        self.init(
            wrapped: wrapped,
            changes: [:]
        )
    }

    public subscript<T>(dynamicMember keyPath: KeyPath<Wrapped, T>) -> T {
        get { changes[keyPath as AnyHashable].flatMap { $0 as? T } ?? wrapped[keyPath: keyPath] }
        set { changes[keyPath as AnyHashable] = newValue }
    }

    public subscript<T: Changeable>(dynamicMember keyPath: KeyPath<Wrapped, T>) -> T.ChangeableCopy {
        get { self[dynamicMember: keyPath].changeableCopy }
        set { self[dynamicMember: keyPath] = T(copy: newValue) }
    }
}

extension Changeable where ChangeableCopy == ChangeableWrapper<Self> {

    public var changeableCopy: ChangeableCopy {
        ChangeableCopy(self)
    }
}

extension ChangeableWrapper: Equatable where
    Wrapped: Equatable & Changeable,
    Wrapped.ChangeableCopy == Self {

    public static func == (lhs: ChangeableWrapper<Wrapped>, rhs: ChangeableWrapper<Wrapped>) -> Bool {
        Wrapped(copy: lhs) == Wrapped(copy: rhs)
    }
}

extension ChangeableWrapper: Hashable where
    Wrapped: Hashable & Changeable,
    Wrapped.ChangeableCopy == Self {

    public func hash(into hasher: inout Hasher) {
        wrapped.hash(into: &hasher)
    }
}

extension ChangeableWrapper: Comparable where
    Wrapped: Comparable & Changeable,
    Wrapped.ChangeableCopy == Self {

    public static func < (lhs: ChangeableWrapper<Wrapped>, rhs: ChangeableWrapper<Wrapped>) -> Bool {
        Wrapped(copy: lhs) < Wrapped(copy: rhs)
    }
}

extension ChangeableWrapper: Decodable where
    Wrapped: Decodable & Changeable,
    Wrapped.ChangeableCopy == Self {

    public init(from decoder: Decoder) throws {
        self.init(try Wrapped(from: decoder))
    }
}

extension ChangeableWrapper: Encodable where
    Wrapped: Encodable & Changeable,
    Wrapped.ChangeableCopy == Self {

    public func encode(to encoder: Encoder) throws {
        try Wrapped(copy: self).encode(to: encoder)
    }
}
