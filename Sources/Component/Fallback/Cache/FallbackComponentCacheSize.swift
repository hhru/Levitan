#if canImport(UIKit)
import CoreGraphics
import Foundation

internal struct FallbackComponentCacheSize: Hashable {

    internal let contentSize: CGSize
    internal let contentSizing: ComponentSizing

    internal let targetSize: CGSize
    internal let reuseSize: CGSize
}
#endif
