#if canImport(UIKit)
import CoreFoundation

internal struct FallbackComponentBodySize {

    internal let extrinsic: CGSize
    internal let intrinsic: CGSize
}

extension FallbackComponentBodySize {

    internal init(size: CGSize) {
        self.init(extrinsic: size, intrinsic: size)
    }

    internal init(width: CGFloat, height: CGFloat) {
        self.init(size: CGSize(width: width, height: height))
    }
}
#endif
