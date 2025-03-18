import CoreGraphics
import Foundation
import SwiftUI

public struct StrokeLineStyle: TokenTraitProvider, Hashable, Sendable {

    public var lineCap: CGLineCap
    public var lineJoin: CGLineJoin
    public var miterLimit: CGFloat
    public var dash: [CGFloat]
    public var dashPhase: CGFloat

    public init(
        lineCap: CGLineCap = .butt,
        lineJoin: CGLineJoin = .miter,
        miterLimit: CGFloat = 10.0,
        dash: [CGFloat] = [],
        dashPhase: CGFloat = 0.0
    ) {
        self.lineCap = lineCap
        self.lineJoin = lineJoin
        self.miterLimit = miterLimit
        self.dash = dash
        self.dashPhase = dashPhase
    }
}

extension StrokeLineStyle {

    public static var `default`: StrokeLineStyle {
        .solid
    }

    public static let solid = StrokeLineStyle()

    public static func dashed(_ dash: [CGFloat], dashPhase: CGFloat = 0.0) -> StrokeLineStyle {
        StrokeLineStyle(
            dash: dash,
            dashPhase: dashPhase
        )
    }
}
