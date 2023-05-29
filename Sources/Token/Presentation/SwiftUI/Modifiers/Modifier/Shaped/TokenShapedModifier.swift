import SwiftUI

public protocol TokenShapedModifier: TokenViewModifier {

    var shape: ShapeToken? { get }
    var shapeInsets: SpacingToken? { get }
}
