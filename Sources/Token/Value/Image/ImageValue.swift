import UIKit
import SwiftUI

public struct ImageValue:
    TokenValue,
    DecorableByResizingMode,
    DecorableByForegroundColor,
    DecorableByInsets,
    Sendable {

    public let source: ImageSource
    public let resizingMode: ImageResizingMode?
    public let foregroundColor: ColorValue?
    public let insets: InsetsValue

    public var uiImage: UIImage {
        var uiImage = source.uiImage

        if let resizingMode {
            uiImage = uiImage.resizableImage(
                withCapInsets: .zero,
                resizingMode: resizingMode.uiResizingMode
            )
        }

        if let foregroundColor = foregroundColor?.uiColor {
            uiImage = uiImage.withTintColor(
                foregroundColor,
                renderingMode: .alwaysOriginal
            )
        }

        if insets != .zero {
            uiImage = uiImage.withAlignmentRectInsets(insets.uiEdgeInsets)
        }

        return uiImage
    }

    public var image: some View {
        source
            .image
            .iflet(resizingMode) { $0.resizable(resizingMode: $1.resizingMode) }
            .if(foregroundColor == nil) { $0.renderingMode(.original) }
            .iflet(foregroundColor) { $0.foregroundColor($1.color) }
            .if(insets != .zero) { $0.padding(insets.edgeInsets) }
    }

    public init(
        source: ImageSource,
        resizingMode: ImageResizingMode? = nil,
        foregroundColor: ColorValue? = nil,
        insets: InsetsValue = .zero
    ) {
        self.source = source
        self.resizingMode = resizingMode
        self.foregroundColor = foregroundColor
        self.insets = insets
    }

    public func resizable(_ resizingMode: ImageResizingMode?) -> Self {
        Self(
            source: source,
            resizingMode: resizingMode,
            foregroundColor: foregroundColor,
            insets: insets
        )
    }

    public func foregroundColor(_ foregroundColor: ColorValue?) -> Self {
        Self(
            source: source,
            resizingMode: resizingMode,
            foregroundColor: foregroundColor,
            insets: insets
        )
    }

    public func inset(by insets: InsetsValue) -> Self {
        Self(
            source: source,
            resizingMode: resizingMode,
            foregroundColor: foregroundColor,
            insets: insets
        )
    }
}

extension ImageValue {

    public static func uiImage(
        _ uiImage: UIImage,
        resizingMode: ImageResizingMode? = nil,
        foregroundColor: ColorValue? = nil,
        insets: InsetsValue = .zero
    ) -> Self {
        Self(
            source: .uiImage(uiImage),
            resizingMode: resizingMode,
            foregroundColor: foregroundColor,
            insets: insets
        )
    }

    public static func resource(
        name: String,
        bundle: Bundle,
        resizingMode: ImageResizingMode? = nil,
        foregroundColor: ColorValue? = nil,
        insets: InsetsValue = .zero
    ) -> Self {
        Self(
            source: .resource(name: name, bundle: bundle),
            resizingMode: resizingMode,
            foregroundColor: foregroundColor,
            insets: insets
        )
    }
}
