#if canImport(UIKit)
import CoreGraphics
import Foundation

@MainActor
internal protocol CollectionViewLayoutBoundsProvider {

    func contentBounds(toPinElements: Bool) -> CGRect
}
#endif
