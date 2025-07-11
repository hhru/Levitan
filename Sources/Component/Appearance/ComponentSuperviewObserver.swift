#if canImport(UIKit)
import Foundation

@MainActor
public protocol ComponentSuperviewObserver: AnyObject {

    func onSuperviewAppear()
    func onSuperviewDisappear()
}
#endif
