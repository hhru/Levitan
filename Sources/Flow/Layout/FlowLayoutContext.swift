#if canImport(UIKit)
import CoreGraphics
import Foundation

@MainActor
public protocol FlowLayoutContext {

    var containerSize: CGSize { get }

    func itemSize(
        at indexPath: IndexPath,
        containerSize: CGSize,
        estimatedSize: CGSize
    ) -> FlowLayoutSize

    func headerSize(
        at index: Int,
        containerSize: CGSize,
        estimatedSize: CGSize
    ) -> FlowLayoutSize

    func footerSize(
        at index: Int,
        containerSize: CGSize,
        estimatedSize: CGSize
    ) -> FlowLayoutSize
}
#endif
