#if canImport(UIKit)
import UIKit
#endif

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

    #if canImport(UIKit)
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
        } else {
            uiImage = uiImage.withRenderingMode(.alwaysOriginal)
        }

        if insets != .zero {
            uiImage = uiImage.withAlignmentRectInsets(insets.uiEdgeInsets)
        }

        return uiImage
    }
    #endif

    public var image: some View {
        source
            .image
            .renderingMode(foregroundColor == nil ? .original : .template)
            .iflet(resizingMode) { $0.resizable(resizingMode: $1.resizingMode) }
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
}

extension ImageValue: Changeable {

    public init(copy: ChangeableWrapper<Self>) {
        self.init(
            source: copy.source,
            resizingMode: copy.resizingMode,
            foregroundColor: copy.foregroundColor,
            insets: copy.insets
        )
    }

    public func resizable(_ resizingMode: ImageResizingMode?) -> Self {
        changing { $0.resizingMode = resizingMode }
    }

    public func foregroundColor(_ foregroundColor: ColorValue?) -> Self {
        changing { $0.foregroundColor = foregroundColor }
    }

    public func inset(by insets: InsetsValue) -> Self {
        changing { $0.insets = insets }
    }
}

extension ImageValue {

    #if canImport(UIKit)
    public static let empty = uiImage(UIImage())

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
    #endif

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
