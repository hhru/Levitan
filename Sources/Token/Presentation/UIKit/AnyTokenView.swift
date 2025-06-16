#if canImport(UIKit)
import Foundation

@MainActor
public protocol AnyTokenView: NSObject {

    var tokenViewManager: TokenViewManager { get }
}
#endif
