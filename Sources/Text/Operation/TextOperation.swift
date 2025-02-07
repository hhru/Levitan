#if canImport(UIKit)
import Foundation

internal struct TextOperation {

    internal let animation: AnimationToken?
    internal let action: () -> Void
}
#endif
