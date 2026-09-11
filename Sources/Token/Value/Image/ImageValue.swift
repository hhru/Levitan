#if canImport(UIKit)
import UIKit
#endif

import SwiftUI

public struct ImageValue:
    TokenValue,
    Changeable,
    Sendable {

    public var source: ImageSource
    public var resizingMode: ImageResizingMode?
    public var primaryColor: ColorValue?
    public var secondaryColor: ColorValue?
    public var tertiaryColor: ColorValue?
    public var insets: InsetsValue
    public var imageSymbolConfiguration: ImageSymbolConfiguration?

    #if canImport(UIKit)
    public var uiImage: UIImage {
        var uiImage = source.uiImage

        if let resizingMode {
            uiImage = uiImage.resizableImage(
                withCapInsets: .zero,
                resizingMode: resizingMode.uiResizingMode
            )
        }

        let colors = [primaryColor?.uiColor, secondaryColor?.uiColor, tertiaryColor?.uiColor]
            .compactMap(\.self)

        if colors.count == 1, let foregroundColor = colors.first {
            uiImage = uiImage.withTintColor(
                foregroundColor,
                renderingMode: .alwaysOriginal
            )
        } else if let primaryColor = primaryColor?.uiColor {
            let foregroundStyleConfiguration = UIImage.SymbolConfiguration(
                paletteColors: colors
            )
            uiImage = uiImage.applyingSymbolConfiguration(foregroundStyleConfiguration)
            ?? uiImage
        } else {
            uiImage = uiImage.withRenderingMode(.alwaysOriginal)
        }

        if let imageSymbolConfigurationSize = imageSymbolConfiguration?.size {
            let fontSizeConfiguration = UIImage.SymbolConfiguration(
                font: .systemFont(ofSize: imageSymbolConfigurationSize)
            )

            uiImage = uiImage
                .applyingSymbolConfiguration(fontSizeConfiguration)?
                .crop(to: CGSize(width: imageSymbolConfigurationSize, height: imageSymbolConfigurationSize))
            ?? uiImage
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
            .renderingMode(primaryColor == nil ? .original : .template)
            .ifImageLet(resizingMode) { $0 = $0.resizable(resizingMode: $1.resizingMode) }
            .iflet(primaryColor) { image, primaryColor in
                switch (secondaryColor, tertiaryColor) {
                case let (secondaryColor?, nil):
                    image
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(
                            primaryColor.color,
                            secondaryColor.color
                        )
                case let (nil, tertiaryColor?):
                    image
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(
                            primaryColor.color,
                            tertiaryColor.color
                        )
                case let (secondaryColor?, tertiaryColor?):
                    image
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(
                            primaryColor.color,
                            secondaryColor.color,
                            tertiaryColor.color,
                        )
                case (nil, nil):
                    image
                        .foregroundStyle(primaryColor.color)
                }
            }
            .iflet(imageSymbolConfiguration) {
                $0
                    .font(.system(size: $1.size))
                    .frame(width: $1.size, height: $1.size)
                    .clipped()
            }
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
        self.primaryColor = foregroundColor
        self.insets = insets
    }
}

extension ImageValue:
    DecorableByResizingMode,
    DecorableByForegroundColor,
    DecorableByForegroundStyle,
    DecorableByImageSymbolConfiguration,
    DecorableByInsets {

    public func resizable(_ resizingMode: ImageResizingMode?) -> Self {
        changing { $0.resizingMode = resizingMode }
    }

    public func foregroundColor(_ foregroundColor: ColorValue?) -> Self {
        changing {
            $0.primaryColor = foregroundColor
            $0.secondaryColor = nil
            $0.tertiaryColor = nil
        }
    }

    public func foregroundStyle(
        _ primaryColor: ColorValue,
        _ secondaryColor: ColorValue?,
        _ tertiaryColor: ColorValue?
    ) -> Self {
        changing {
            $0.primaryColor = primaryColor
            $0.secondaryColor = secondaryColor
            $0.tertiaryColor = tertiaryColor
        }
    }

    public func inset(by insets: InsetsValue) -> Self {
        changing { $0.insets = insets }
    }

    public func imageSymbolConfiguration(_ imageSymbolConfiguration: ImageSymbolConfiguration?) -> Self {
        changing { $0.imageSymbolConfiguration = imageSymbolConfiguration }
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
