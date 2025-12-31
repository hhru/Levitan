#if canImport(UIKit)
import CoreGraphics
import Foundation

@MainActor
internal struct CollectionViewLayoutScrollAnchorItem {

    internal let path: ItemPath
    internal let part: CGFloat
}
#endif
