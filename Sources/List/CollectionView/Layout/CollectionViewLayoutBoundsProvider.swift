import CoreFoundation

internal protocol CollectionViewLayoutBoundsProvider {

    func contentBounds(toPinElements: Bool) -> CGRect
}
