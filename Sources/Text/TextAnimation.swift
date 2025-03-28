#if canImport(UIKit)
import Foundation

public struct TextAnimation: Hashable {

    public let update: AnimationToken?

    public let press: AnimationToken?
    public let unpress: AnimationToken?

    public let hover: AnimationToken?
    public let unhover: AnimationToken?

    public init(
        update: AnimationToken? = nil,
        press: AnimationToken? = nil,
        unpress: AnimationToken? = nil,
        hover: AnimationToken? = nil,
        unhover: AnimationToken? = nil
    ) {
        self.update = update

        self.press = press
        self.unpress = unpress

        self.hover = hover
        self.unhover = unhover
    }
}

extension TextAnimation {

    public static let none = Self()

    public static let `default` = Self(
        press: .easeInEaseOut(duration: 100),
        unpress: .easeInEaseOut(duration: 200),
        hover: .easeInEaseOut(duration: 100),
        unhover: .easeInEaseOut(duration: 200)
    )
}
#endif
