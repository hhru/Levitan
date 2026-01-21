#if canImport(UIKit)
import Foundation

@MainActor
internal protocol ComponentSubviewAppearance: AnyObject {

    func onSuperviewAppear()
    func onSuperviewDisappear()
}
#endif
