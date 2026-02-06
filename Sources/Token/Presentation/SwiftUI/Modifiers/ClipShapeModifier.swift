import SwiftUI

public struct ClipShapeModifier<Content: View>: Hashable, Sendable {

    public let shape: ShapeToken?

    public init(shape: ShapeToken?) {
        self.shape = shape
    }
}

extension ClipShapeModifier: TokenViewModifier {

    public func body(content: Content, theme: TokenTheme) -> some View {
        if let shape = shape?.resolve(for: theme) {
            content.clipShape(shape)
        } else {
            content
        }
    }
}

extension ClipShapeModifier: TokenShapedModifier {

    public var shapeInsets: SpacingToken? {
        nil
    }
}

extension View {

    public nonisolated func clipShape(
        _ shape: ShapeToken?
    ) -> TokenModifiedView<ClipShapeModifier<Self>> {
        modifier(ClipShapeModifier(shape: shape))
    }

    public nonisolated func corners(
        _ corners: CornersToken?
    ) -> TokenModifiedView<ClipShapeModifier<Self>> {
        clipShape(corners.map { .rectangle(corners: $0) })
    }

    public nonisolated func corners(
        radius: CornerRadiusToken?,
        mask: CornersMask = .all
    ) -> TokenModifiedView<ClipShapeModifier<Self>> {
        corners(radius.map { CornersToken(radius: $0, mask: mask) })
    }
}
