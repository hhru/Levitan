import CoreGraphics

extension CGFloat:
    TokenValue,
    DecorableByNegation,
    DecorableByPlus,
    DecorableByMinus,
    DecorableByMultiplication,
    DecorableByDivision { }

public typealias ScalingToken = Token<CGFloat>
public typealias SpacingToken = Token<CGFloat>
public typealias CornerRadiusToken = Token<CGFloat>
public typealias StrokeWidthToken = Token<CGFloat>
public typealias OpacityToken = Token<CGFloat>
public typealias FontSizeToken = Token<CGFloat>
