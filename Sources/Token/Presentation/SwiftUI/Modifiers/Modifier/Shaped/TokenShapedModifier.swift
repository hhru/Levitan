import SwiftUI

public protocol TokenShapedModifier {

    var shape: ShapeToken? { get }
    var shapeInsets: SpacingToken? { get }
}
