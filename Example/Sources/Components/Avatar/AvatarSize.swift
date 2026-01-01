import Foundation

struct AvatarSize: Equatable, Sendable {

    let value: CGFloat
}

extension AvatarSize {

    static let small = Self(value: 48.0)
    static let large = Self(value: 120.0)
}
