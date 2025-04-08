#if canImport(UIKit)
import CoreFoundation

internal protocol CollectionViewLayoutBoundsProvider {

    func contentBounds(toPinElements: Bool) -> CGRect
}
#endif
