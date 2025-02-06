#if canImport(UIKit1)
import UIKit

public typealias FontToken = Token<FontValue>

extension FontToken {

    public init(
        source: FontSource,
        size: FontSizeToken,
        scale: FontScaleToken? = nil
    ) {
        self = Token(traits: [source, size, scale]) { theme in
            Value(
                source: source,
                size: size.resolve(for: theme),
                scale: scale?.resolve(for: theme)
            )
        }
    }

    public init(
        weight: FontWeightToken,
        size: FontSizeToken,
        scale: FontScaleToken? = nil
    ) {
        self = Token(traits: [weight, size, scale]) { theme in
            Value(
                weight: weight.resolve(for: theme),
                size: size.resolve(for: theme),
                scale: scale?.resolve(for: theme)
            )
        }
    }
}

extension FontToken {

    public static func system(
        weight: UIFont.Weight,
        size: FontSizeToken,
        scale: FontScaleToken? = nil
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
        size: FontSizeToken,
        scale: FontScaleToken? = nil
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
        size: FontSizeToken,
        scale: FontScaleToken? = nil
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
        size: FontSizeToken,
        scale: FontScaleToken? = nil
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
        size: FontSizeToken,
        scale: FontScaleToken? = nil
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
        size: FontSizeToken,
        scale: FontScaleToken? = nil
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
#endif
