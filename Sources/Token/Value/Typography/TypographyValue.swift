import UIKit

public struct TypographyValue:
    TokenValue,
    DecorableByFontScale,
    DecorableByForegroundColor,
    DecorableByBackgroundColor,
    DecorableByStroke,
    DecorableByStrikethrough,
    DecorableByUnderline,
    DecorableByLetterSpacing,
    DecorableByParagraphSpacing,
    DecorableByParagraphFirstLineIndent,
    DecorableByParagraphOtherLineIndent,
    DecorableByLineHeight,
    DecorableByLineBreakMode,
    DecorableByAlignment,
    Sendable {

    public let font: FontValue
    public let foregroundColor: ColorValue?
    public let backgroundColor: ColorValue?
    public let stroke: TypographyStrokeValue?
    public let strikethrough: TypographyLineValue?
    public let underline: TypographyLineValue?
    public let letterSpacing: CGFloat?
    public let paragraphSpacing: CGFloat?
    public let paragraphFirstLineIndent: CGFloat?
    public let paragraphOtherLineIndent: CGFloat?
    public let lineHeight: CGFloat?
    public let lineBreakMode: NSLineBreakMode?
    public let alignment: NSTextAlignment?

    public var paragraphStyle: NSParagraphStyle {
        resolveParagraphStyle()
    }

    public var attributes: [NSAttributedString.Key: Any] {
        resolveAttributes(paragraphStyle: paragraphStyle)
    }

    public var attributesWithoutParagraphStyle: [NSAttributedString.Key: Any] {
        resolveAttributes(paragraphStyle: nil)
    }

    public var minimumLineHeight: CGFloat {
        paragraphStyle.minimumLineHeight
    }

    public var maximumLineHeight: CGFloat {
        paragraphStyle.maximumLineHeight
    }

    public init(
        font: FontValue,
        foregroundColor: ColorValue? = nil,
        backgroundColor: ColorValue? = nil,
        stroke: TypographyStrokeValue? = nil,
        strikethrough: TypographyLineValue? = nil,
        underline: TypographyLineValue? = nil,
        letterSpacing: CGFloat? = nil,
        paragraphSpacing: CGFloat? = nil,
        paragraphFirstLineIndent: CGFloat? = nil,
        paragraphOtherLineIndent: CGFloat? = nil,
        lineHeight: CGFloat? = nil,
        lineBreakMode: NSLineBreakMode? = nil,
        alignment: NSTextAlignment? = nil
    ) {
        self.font = font
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.stroke = stroke
        self.strikethrough = strikethrough
        self.underline = underline
        self.letterSpacing = letterSpacing
        self.paragraphSpacing = paragraphSpacing
        self.paragraphFirstLineIndent = paragraphFirstLineIndent
        self.paragraphOtherLineIndent = paragraphOtherLineIndent
        self.lineHeight = lineHeight
        self.lineBreakMode = lineBreakMode
        self.alignment = alignment
    }

    public init(
        fontWeight: String,
        fontSize: CGFloat,
        fontScale: FontScaleValue? = nil,
        foregroundColor: ColorValue? = nil,
        backgroundColor: ColorValue? = nil,
        stroke: TypographyStrokeValue? = nil,
        strikethrough: TypographyLineValue? = nil,
        underline: TypographyLineValue? = nil,
        letterSpacing: CGFloat? = nil,
        paragraphSpacing: CGFloat? = nil,
        paragraphFirstLineIndent: CGFloat? = nil,
        paragraphOtherLineIndent: CGFloat? = nil,
        lineHeight: CGFloat? = nil,
        lineBreakMode: NSLineBreakMode? = nil,
        alignment: NSTextAlignment? = nil
    ) {
        self.init(
            font: FontValue(
                weight: fontWeight,
                size: fontSize,
                scale: fontScale
            ),
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor,
            stroke: stroke,
            strikethrough: strikethrough,
            underline: underline,
            letterSpacing: letterSpacing,
            paragraphSpacing: paragraphSpacing,
            paragraphFirstLineIndent: paragraphFirstLineIndent,
            paragraphOtherLineIndent: paragraphOtherLineIndent,
            lineHeight: lineHeight,
            lineBreakMode: lineBreakMode,
            alignment: alignment
        )
    }

    private func resolveParagraphStyle() -> NSParagraphStyle {
        let scale = font.scale
        let font = font.uiFont

        let paragraphStyle = NSMutableParagraphStyle()

        let lineHeight = lineHeight.map { lineHeight in
            scale
                .map { UIFontMetrics(forTextStyle: $0.textStyle) }
                .map { $0.scaledValue(for: lineHeight) }
                .map { min($0, lineHeight) }
                .map { max($0, font.lineHeight) } ?? lineHeight
        }

        if let lineHeight {
            paragraphStyle.minimumLineHeight = lineHeight
            paragraphStyle.maximumLineHeight = lineHeight
        }

        if let paragraphSpacing {
            paragraphStyle.paragraphSpacing = paragraphSpacing
        }

        if let paragraphFirstLineIndent {
            paragraphStyle.firstLineHeadIndent = paragraphFirstLineIndent
        }

        if let paragraphOtherLineIndent {
            paragraphStyle.headIndent = paragraphOtherLineIndent
        }

        if let lineBreakMode {
            paragraphStyle.lineBreakMode = lineBreakMode
        }

        if let alignment {
            paragraphStyle.alignment = alignment
        }

        return paragraphStyle
    }

    private func resolveAttributes(paragraphStyle: NSParagraphStyle?) -> [NSAttributedString.Key: Any] {
        let font = font.uiFont

        var attributes: [NSAttributedString.Key: Any] = [
            .font: font
        ]

        if let foregroundColor {
            attributes[.foregroundColor] = foregroundColor.uiColor
        }

        if let backgroundColor {
            attributes[.backgroundColor] = backgroundColor.uiColor
        }

        if let stroke {
            attributes[.strokeWidth] = stroke.width
            attributes[.strokeColor] = stroke.color
        }

        if let strikethrough {
            attributes[.strikethroughStyle] = strikethrough.style.rawValue
            attributes[.strikethroughColor] = strikethrough.color?.uiColor
        }

        if let underline {
            attributes[.underlineStyle] = underline.style.rawValue
            attributes[.strikethroughColor] = underline.color?.uiColor
        }

        if let letterSpacing {
            attributes[.kern] = letterSpacing
        }

        if let paragraphStyle {
            let baselineOffset = paragraphStyle.maximumLineHeight > .zero
                ? 0.25 * (paragraphStyle.maximumLineHeight - font.lineHeight)
                : 0.0

            attributes[.baselineOffset] = baselineOffset
            attributes[.paragraphStyle] = paragraphStyle
        }

        return attributes
    }

    public func fontScale(_ fontScale: FontScaleValue?) -> Self {
        Self(
            font: font.scale(fontScale),
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor,
            stroke: stroke,
            strikethrough: strikethrough,
            underline: underline,
            letterSpacing: letterSpacing,
            paragraphSpacing: paragraphSpacing,
            paragraphFirstLineIndent: paragraphFirstLineIndent,
            paragraphOtherLineIndent: paragraphOtherLineIndent,
            lineHeight: lineHeight,
            lineBreakMode: lineBreakMode,
            alignment: alignment
        )
    }

    public func foregroundColor(_ foregroundColor: ColorValue?) -> Self {
        Self(
            font: font,
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor,
            stroke: stroke,
            strikethrough: strikethrough,
            underline: underline,
            letterSpacing: letterSpacing,
            paragraphSpacing: paragraphSpacing,
            paragraphFirstLineIndent: paragraphFirstLineIndent,
            paragraphOtherLineIndent: paragraphOtherLineIndent,
            lineHeight: lineHeight,
            lineBreakMode: lineBreakMode,
            alignment: alignment
        )
    }

    public func backgroundColor(_ backgroundColor: ColorValue?) -> Self {
        Self(
            font: font,
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor,
            stroke: stroke,
            strikethrough: strikethrough,
            underline: underline,
            letterSpacing: letterSpacing,
            paragraphSpacing: paragraphSpacing,
            paragraphFirstLineIndent: paragraphFirstLineIndent,
            paragraphOtherLineIndent: paragraphOtherLineIndent,
            lineHeight: lineHeight,
            lineBreakMode: lineBreakMode,
            alignment: alignment
        )
    }

    public func stroke(_ stroke: TypographyStrokeValue?) -> Self {
        Self(
            font: font,
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor,
            stroke: stroke,
            strikethrough: strikethrough,
            underline: underline,
            letterSpacing: letterSpacing,
            paragraphSpacing: paragraphSpacing,
            paragraphFirstLineIndent: paragraphFirstLineIndent,
            paragraphOtherLineIndent: paragraphOtherLineIndent,
            lineHeight: lineHeight,
            lineBreakMode: lineBreakMode,
            alignment: alignment
        )
    }

    public func strikethrough(_ strikethrough: TypographyLineValue?) -> Self {
        Self(
            font: font,
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor,
            stroke: stroke,
            strikethrough: strikethrough,
            underline: underline,
            letterSpacing: letterSpacing,
            paragraphSpacing: paragraphSpacing,
            paragraphFirstLineIndent: paragraphFirstLineIndent,
            paragraphOtherLineIndent: paragraphOtherLineIndent,
            lineHeight: lineHeight,
            lineBreakMode: lineBreakMode,
            alignment: alignment
        )
    }

    public func underline(_ strikethrough: TypographyLineValue?) -> Self {
        Self(
            font: font,
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor,
            stroke: stroke,
            strikethrough: strikethrough,
            underline: underline,
            letterSpacing: letterSpacing,
            paragraphSpacing: paragraphSpacing,
            paragraphFirstLineIndent: paragraphFirstLineIndent,
            paragraphOtherLineIndent: paragraphOtherLineIndent,
            lineHeight: lineHeight,
            lineBreakMode: lineBreakMode,
            alignment: alignment
        )
    }

    public func letterSpacing(_ letterSpacing: CGFloat?) -> Self {
        Self(
            font: font,
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor,
            stroke: stroke,
            strikethrough: strikethrough,
            underline: underline,
            letterSpacing: letterSpacing,
            paragraphSpacing: paragraphSpacing,
            paragraphFirstLineIndent: paragraphFirstLineIndent,
            paragraphOtherLineIndent: paragraphOtherLineIndent,
            lineHeight: lineHeight,
            lineBreakMode: lineBreakMode,
            alignment: alignment
        )
    }

    public func paragraphSpacing(_ paragraphSpacing: CGFloat?) -> Self {
        Self(
            font: font,
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor,
            stroke: stroke,
            strikethrough: strikethrough,
            underline: underline,
            letterSpacing: letterSpacing,
            paragraphSpacing: paragraphSpacing,
            paragraphFirstLineIndent: paragraphFirstLineIndent,
            paragraphOtherLineIndent: paragraphOtherLineIndent,
            lineHeight: lineHeight,
            lineBreakMode: lineBreakMode,
            alignment: alignment
        )
    }

    public func paragraphFirstLineIndent(_ paragraphFirstLineIndent: CGFloat?) -> Self {
        Self(
            font: font,
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor,
            stroke: stroke,
            strikethrough: strikethrough,
            underline: underline,
            letterSpacing: letterSpacing,
            paragraphSpacing: paragraphSpacing,
            paragraphFirstLineIndent: paragraphFirstLineIndent,
            paragraphOtherLineIndent: paragraphOtherLineIndent,
            lineHeight: lineHeight,
            lineBreakMode: lineBreakMode,
            alignment: alignment
        )
    }

    public func paragraphOtherLineIndent(_ paragraphOtherLineIndent: CGFloat?) -> Self {
        Self(
            font: font,
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor,
            stroke: stroke,
            strikethrough: strikethrough,
            underline: underline,
            letterSpacing: letterSpacing,
            paragraphSpacing: paragraphSpacing,
            paragraphFirstLineIndent: paragraphFirstLineIndent,
            paragraphOtherLineIndent: paragraphOtherLineIndent,
            lineHeight: lineHeight,
            lineBreakMode: lineBreakMode,
            alignment: alignment
        )
    }

    public func lineHeight(_ lineHeight: CGFloat?) -> Self {
        Self(
            font: font,
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor,
            stroke: stroke,
            strikethrough: strikethrough,
            underline: underline,
            letterSpacing: letterSpacing,
            paragraphSpacing: paragraphSpacing,
            paragraphFirstLineIndent: paragraphFirstLineIndent,
            paragraphOtherLineIndent: paragraphOtherLineIndent,
            lineHeight: lineHeight,
            lineBreakMode: lineBreakMode,
            alignment: alignment
        )
    }

    public func lineBreakMode(_ lineBreakMode: NSLineBreakMode?) -> Self {
        Self(
            font: font,
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor,
            stroke: stroke,
            strikethrough: strikethrough,
            underline: underline,
            letterSpacing: letterSpacing,
            paragraphSpacing: paragraphSpacing,
            paragraphFirstLineIndent: paragraphFirstLineIndent,
            paragraphOtherLineIndent: paragraphOtherLineIndent,
            lineHeight: lineHeight,
            lineBreakMode: lineBreakMode,
            alignment: alignment
        )
    }

    public func alignment(_ alignment: NSTextAlignment?) -> Self {
        Self(
            font: font,
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor,
            stroke: stroke,
            strikethrough: strikethrough,
            underline: underline,
            letterSpacing: letterSpacing,
            paragraphSpacing: paragraphSpacing,
            paragraphFirstLineIndent: paragraphFirstLineIndent,
            paragraphOtherLineIndent: paragraphOtherLineIndent,
            lineHeight: lineHeight,
            lineBreakMode: lineBreakMode,
            alignment: alignment
        )
    }
}
