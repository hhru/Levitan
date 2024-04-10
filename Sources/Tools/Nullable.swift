import Foundation

internal protocol Nullable {

    var isNil: Bool { get }
}

extension Optional: Nullable {

    internal var isNil: Bool {
        self == nil
    }
}
