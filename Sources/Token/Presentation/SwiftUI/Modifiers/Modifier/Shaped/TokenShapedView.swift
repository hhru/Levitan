import SwiftUI

public protocol TokenShapedView {

    var shape: ShapeToken? { get }
    var shapeInsets: SpacingToken? { get }
}

extension TokenModifiedView: TokenShapedView where Modifier: TokenShapedModifier {

    public var shape: ShapeToken? {
        modifier.shape
    }

    public var shapeInsets: SpacingToken? {
        modifier.shapeInsets
    }
}
