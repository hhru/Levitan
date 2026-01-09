#if canImport(UIKit)
import CoreGraphics
import Foundation

internal struct CollectionViewLayoutSizing: Equatable {

    internal let width: ComponentSizingStrategy
    internal let height: ComponentSizingStrategy

    internal let containerSize: CGSize
    internal let boundingSize: CGSize
}
#endif
