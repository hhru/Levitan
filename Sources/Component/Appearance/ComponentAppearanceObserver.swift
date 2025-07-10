#if canImport(UIKit)
import Foundation

@MainActor
public protocol ComponentAppearanceObserver: AnyObject {

    func onAppear()
    func onDisappear()
}
#endif
