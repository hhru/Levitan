#if canImport(UIKit)
import CoreFoundation

internal struct FallbackComponentBodySize {

    internal let intrinsic: CGSize
    internal let extrinsic: CGSize
}

extension FallbackComponentBodySize {

    internal init(size: CGSize) {
        self.init(
            intrinsic: size,
            extrinsic: size
        )
    }

    internal init(width: CGFloat, height: CGFloat) {
        self.init(size: CGSize(width: width, height: height))
    }
}
#endif
