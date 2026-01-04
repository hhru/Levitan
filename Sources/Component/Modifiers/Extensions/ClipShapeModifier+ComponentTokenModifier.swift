#if canImport(UIKit)
import Foundation

extension ClipShapeModifier: ComponentTokenModifier where Content: Component { }

extension Component {

    public nonisolated func clipShape(_ shape: ShapeToken?) -> some Component & TokenShapedView {
        modifier(ClipShapeModifier(shape: shape))
    }

    public nonisolated func corners(_ corners: CornersToken?) -> some Component & TokenShapedView {
        clipShape(corners.map { .rectangle(corners: $0) })
    }

    public nonisolated func corners(
        radius: CornerRadiusToken?,
        mask: CornersMask = .all
    ) -> some Component & TokenShapedView {
        corners(radius.map { CornersToken(radius: $0, mask: mask) })
    }
}
#endif
