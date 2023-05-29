import Foundation

public typealias GradientToken = Token<GradientValue>

extension GradientToken {

    public init(
        colors: [ColorToken],
        locations: [CGFloat]? = nil,
        startPoint: CGPoint,
        endPoint: CGPoint
    ) {
        self = Token(traits: [colors, locations, startPoint, endPoint]) { theme in
            Value(
                colors: colors.map { $0.resolve(for: theme) },
                locations: locations,
                startPoint: startPoint,
                endPoint: endPoint
            )
        }
    }
}

extension GradientToken {

    public static var clear: Self {
        Self(
            colors: [],
            locations: nil,
            startPoint: CGPoint(x: 0.5, y: 0.0),
            endPoint: CGPoint(x: 0.5, y: 1.0)
        )
    }

    public static func horizontal(
        colors: [ColorToken],
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
        colors: [ColorToken],
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

    public init(
        colors: [ColorToken],
        startPoint: CGPoint,
        endPoint: CGPoint
    ) {
        self.init(
            colors: colors,
            locations: nil,
            startPoint: startPoint,
            endPoint: endPoint
        )
    }
}
