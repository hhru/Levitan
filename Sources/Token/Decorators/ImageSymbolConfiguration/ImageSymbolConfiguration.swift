#if os(iOS) || os(tvOS)
import UIKit
#else
import AppKit
#endif

public struct ImageSymbolConfiguration: Sendable, Hashable {

    let size: CGFloat

    public init(size: CGFloat) {
        self.size = size
    }
}
