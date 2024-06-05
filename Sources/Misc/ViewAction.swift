import Foundation

// TODO: Добавить документацию
@propertyWrapper
public struct ViewAction<Value> {

    public var wrappedValue: Value

    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
}

extension ViewAction: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs.wrappedValue as? Nullable, rhs.wrappedValue as? Nullable) {
        case let (lhs?, rhs?):
            return lhs.isNil == rhs.isNil

        case (nil, nil), (nil, _?), (_?, nil):
            return true
        }
    }
}

extension ViewAction: Hashable {

    public func hash(into hasher: inout Hasher) {
        if let value = wrappedValue as? Nullable, value.isNil {
            hasher.combine(false)
        } else {
            hasher.combine(true)
        }
    }
}
