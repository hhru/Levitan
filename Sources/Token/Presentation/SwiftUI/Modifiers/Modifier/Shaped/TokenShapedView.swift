import SwiftUI

public protocol TokenShapedView: View {

    nonisolated var shape: ShapeToken? { get }
    nonisolated var shapeInsets: SpacingToken? { get }
}

extension TokenModifiedView: TokenShapedView
where Modifier: TokenShapedModifier {

    public var shape: ShapeToken? {
        modifier.shape
    }

    public var shapeInsets: SpacingToken? {
        modifier.shapeInsets
    }
}
