#if canImport(UIKit)
import Foundation

@MainActor
public protocol ComponentAppearanceView: AnyObject {

    func onViewAppear()
    func onViewDisappear()
}

extension ComponentAppearanceView {

    public func onViewAppear() { }
    public func onViewDisappear() { }
}
#endif
