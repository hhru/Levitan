import UIKit
import SwiftUI

public struct FontValue: TokenValue, Sendable {

    public let source: FontSource
    public let size: CGFloat
    public let scale: FontScaleValue?

    public var uiFont: UIFont {
        let uiFont: UIFont

        switch source {
        case let .uiFont(_, builder):
            uiFont = builder(size)

        case let .resource(weight):
            uiFont = UIFont(
                name: weight,
                size: size
            ) ?? .systemFont(ofSize: size)
        }

        guard let scale else {
            return uiFont
        }

        let metrics = UIFontMetrics(forTextStyle: scale.textStyle)

        guard let maxPointSize = scale.maxPointSize else {
            return metrics.scaledFont(for: uiFont)
        }

        return metrics.scaledFont(
            for: uiFont,
            maximumPointSize: maxPointSize
        )
    }

    public var font: Font {
        Font(uiFont)
    }

    public init(
        source: FontSource,
        size: CGFloat,
        scale: FontScaleValue? = nil
    ) {
        self.source = source
        self.size = size
        self.scale = scale
    }

    public init(
        weight: String,
        size: CGFloat,
        scale: FontScaleValue? = nil
    ) {
        self.init(
            source: .resource(weight: weight),
            size: size,
            scale: scale
        )
    }
}

extension FontValue: Changeable {

    public init(copy: ChangeableWrapper<Self>) {
        self.init(
            source: copy.source,
            size: copy.size,
            scale: copy.scale
        )
    }

    public func size(_ size: CGFloat) -> Self {
        changing { $0.size = size }
    }

    public func scale(_ scale: FontScaleValue?) -> Self {
        changing { $0.scale = scale }
    }
}

extension FontValue {

    public static func system(
        weight: UIFont.Weight,
        size: CGFloat,
        scale: FontScaleValue? = nil
    ) -> Self {
        Self(
            source: .uiFont(trait: #function) { size in
                .systemFont(ofSize: size, weight: weight)
            },
            size: size,
            scale: scale
        )
    }

    public static func system(
        size: CGFloat,
        scale: FontScaleValue? = nil
    ) -> Self {
        Self(
            source: .uiFont(trait: #function) { size in
                .systemFont(ofSize: size)
            },
            size: size,
            scale: scale
        )
    }

    public static func italicSystem(
        size: CGFloat,
        scale: FontScaleValue? = nil
    ) -> Self {
        Self(
            source: .uiFont(trait: #function) { size in
                .italicSystemFont(ofSize: size)
            },
            size: size,
            scale: scale
        )
    }

    public static func boldSystem(
        size: CGFloat,
        scale: FontScaleValue? = nil
    ) -> Self {
        Self(
            source: .uiFont(trait: #function) { size in
                .boldSystemFont(ofSize: size)
            },
            size: size,
            scale: scale
        )
    }

    public static func monospacedSystem(
        weight: UIFont.Weight,
        size: CGFloat,
        scale: FontScaleValue? = nil
    ) -> Self {
        Self(
            source: .uiFont(trait: #function) { size in
                .monospacedSystemFont(ofSize: size, weight: weight)
            },
            size: size,
            scale: scale
        )
    }

    public static func monospacedDigitSystem(
        weight: UIFont.Weight,
        size: CGFloat,
        scale: FontScaleValue? = nil
    ) -> Self {
        Self(
            source: .uiFont(trait: #function) { size in
                .monospacedDigitSystemFont(ofSize: size, weight: weight)
            },
            size: size,
            scale: scale
        )
    }
}
