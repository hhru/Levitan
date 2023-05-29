import UIKit
import SwiftUI

public struct GradientValue: TokenValue, Sendable {

    public let colors: [ColorValue]
    public let locations: [CGFloat]?
    public let startPoint: CGPoint
    public let endPoint: CGPoint

    public var linearGradient: LinearGradient {
        let colors = colors.map { $0.color }

        let startPoint = UnitPoint(x: startPoint.x, y: startPoint.y)
        let endPoint = UnitPoint(x: endPoint.x, y: endPoint.y)

        guard let locations, locations.count == colors.count else {
            return LinearGradient(
                colors: colors,
                startPoint: startPoint,
                endPoint: endPoint
            )
        }

        let stops = colors.enumerated().map { index, color in
            Gradient.Stop(color: color, location: locations[index])
        }

        return LinearGradient(
            gradient: Gradient(stops: stops),
            startPoint: startPoint,
            endPoint: endPoint
        )
    }

    public var isEmpty: Bool {
        colors.isEmpty
    }

    public init(
        colors: [ColorValue],
        locations: [CGFloat]? = nil,
        startPoint: CGPoint,
        endPoint: CGPoint
    ) {
        self.colors = colors
        self.locations = locations
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
}

extension GradientValue {

    public static var clear: Self {
        Self(
            colors: [],
            locations: nil,
            startPoint: CGPoint(x: 0.5, y: 0.0),
            endPoint: CGPoint(x: 0.5, y: 1.0)
        )
    }

    public static func horizontal(
        colors: [ColorValue],
        locations: [CGFloat]? = nil,
        startPoint: CGFloat = .zero,
        endPoint: CGFloat = 1.0
    ) -> Self {
        Self(
            colors: colors,
            locations: locations,
            startPoint: CGPoint(x: startPoint, y: 0.5),
            endPoint: CGPoint(x: endPoint, y: 0.5)
        )
    }

    public static func vertical(
        colors: [ColorValue],
        locations: [CGFloat]? = nil,
        startPoint: CGFloat = .zero,
        endPoint: CGFloat = 1.0
    ) -> Self {
        Self(
            colors: colors,
            locations: locations,
            startPoint: CGPoint(x: 0.5, y: startPoint),
            endPoint: CGPoint(x: 0.5, y: endPoint)
        )
    }
}
