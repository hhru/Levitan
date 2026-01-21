#if canImport(UIKit)
import Foundation

@MainActor
public protocol ComponentSuperviewAppearance: AnyObject, Sendable {

    var isExist: Bool { get }

    func connectAppearance(
        _ appearance: ComponentAppearance,
        of view: ComponentAppearanceView
    )
}
#endif
