import CoreGraphics

public protocol ListLayoutContext {

    var containerSize: CGSize { get }

    func itemSize(
        at indexPath: IndexPath,
        proposedSize: CGSize,
        estimatedSize: CGSize
    ) -> ListLayoutSize

    func headerSize(
        at index: Int,
        proposedSize: CGSize,
        estimatedSize: CGSize
    ) -> ListLayoutSize

    func footerSize(
        at index: Int,
        proposedSize: CGSize,
        estimatedSize: CGSize
    ) -> ListLayoutSize
}
