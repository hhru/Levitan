#if canImport(UIKit)
import UIKit
#else
import Foundation
#endif

public typealias ImageToken = Token<ImageValue>

extension ImageToken {

    public init(
        source: ImageSource,
        resizingMode: ImageResizingMode? = nil,
        foregroundColor: ColorToken? = nil,
        insets: InsetsToken = .zero
    ) {
        self = Token(traits: [source, resizingMode, foregroundColor, insets]) { theme in
            Value(
                source: source,
                resizingMode: resizingMode,
                foregroundColor: foregroundColor?.resolve(for: theme),
                insets: insets.resolve(for: theme)
            )
        }
    }
}

extension ImageToken {

    #if canImport(UIKit)
    public static let empty = uiImage(UIImage())

    public static func uiImage(
        _ uiImage: UIImage,
        resizingMode: ImageResizingMode? = nil,
        foregroundColor: ColorToken? = nil,
        insets: InsetsToken = .zero
    ) -> Self {
        Self(
            source: .uiImage(uiImage),
            resizingMode: resizingMode,
            foregroundColor: foregroundColor,
            insets: insets
        )
    }
    #endif

    public static func resource(
        name: String,
        bundle: Bundle,
        resizingMode: ImageResizingMode? = nil,
        foregroundColor: ColorToken? = nil,
        insets: InsetsToken = .zero
    ) -> Self {
        Self(
            source: .resource(name: name, bundle: bundle),
            resizingMode: resizingMode,
            foregroundColor: foregroundColor,
            insets: insets
        )
    }
}
