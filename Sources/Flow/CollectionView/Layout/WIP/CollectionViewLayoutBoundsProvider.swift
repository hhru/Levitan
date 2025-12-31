#if canImport(UIKit)
import CoreFoundation

@MainActor
internal protocol CollectionViewLayoutBoundsProvider {

    func contentBounds(toPinElements: Bool) -> CGRect
}
#endif
