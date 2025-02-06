#if canImport(UIKit1)
import UIKit

public struct TypographyValue:
    TokenValue,
    DecorableByFontScale,
    DecorableByFontSize,
    DecorableByLetterSpacing,
    DecorableByLineHeight,
    DecorableByParagraphSpacing,
    DecorableByParagraphFirstLineIndent,
    DecorableByParagraphOtherLineIndent,
    DecorableByAlignment,
    DecorableByForegroundColor,
    DecorableByBackgroundColor,
    DecorableByStroke,
    DecorableByStrikethrough,
    DecorableByUnderline,
    DecorableByLineBreakMode,
    Sendable {

    public let font: FontValue

    public let letterSpacing: CGFloat?
    public let lineHeight: CGFloat?
    public let paragraphSpacing: CGFloat?
    public let paragraphFirstLineIndent: CGFloat?
    public let paragraphOtherLineIndent: CGFloat?
    public let alignment: NSTextAlignment?

    public let foregroundColor: ColorValue?
    public let backgroundColor: ColorValue?
    public let stroke: TypographyStrokeValue?
    public let strikethrough: TypographyLineValue?
    public let underline: TypographyLineValue?

    // TODO: Удалить после миграции в проекте
    public let lineBreakMode: NSLineBreakMode?

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
        letterSpacing: CGFloat? = nil,
        lineHeight: CGFloat? = nil,
        paragraphSpacing: CGFloat? = nil,
        paragraphFirstLineIndent: CGFloat? = nil,
        paragraphOtherLineIndent: CGFloat? = nil,
        alignment: NSTextAlignment? = nil,
        foregroundColor: ColorValue? = nil,
        backgroundColor: ColorValue? = nil,
        stroke: TypographyStrokeValue? = nil,
        strikethrough: TypographyLineValue? = nil,
        underline: TypographyLineValue? = nil,
        lineBreakMode: NSLineBreakMode? = nil
    ) {
        self.font = font

        self.letterSpacing = letterSpacing
        self.lineHeight = lineHeight
        self.paragraphSpacing = paragraphSpacing
        self.paragraphFirstLineIndent = paragraphFirstLineIndent
        self.paragraphOtherLineIndent = paragraphOtherLineIndent
        self.alignment = alignment

        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.stroke = stroke
        self.strikethrough = strikethrough
        self.underline = underline

        self.lineBreakMode = lineBreakMode
    }

    public init(
        fontWeight: String,
        fontSize: CGFloat,
        fontScale: FontScaleValue? = nil,
        letterSpacing: CGFloat? = nil,
        lineHeight: CGFloat? = nil,
        paragraphSpacing: CGFloat? = nil,
        paragraphFirstLineIndent: CGFloat? = nil,
        paragraphOtherLineIndent: CGFloat? = nil,
        alignment: NSTextAlignment? = nil,
        foregroundColor: ColorValue? = nil,
        backgroundColor: ColorValue? = nil,
        stroke: TypographyStrokeValue? = nil,
        strikethrough: TypographyLineValue? = nil,
        underline: TypographyLineValue? = nil,
        lineBreakMode: NSLineBreakMode? = nil
    ) {
        self.init(
            font: FontValue(
                weight: fontWeight,
                size: fontSize,
                scale: fontScale
            ),
            letterSpacing: letterSpacing,
            lineHeight: lineHeight,
            paragraphSpacing: paragraphSpacing,
            paragraphFirstLineIndent: paragraphFirstLineIndent,
            paragraphOtherLineIndent: paragraphOtherLineIndent,
            alignment: alignment,
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor,
            stroke: stroke,
            strikethrough: strikethrough,
            underline: underline,
            lineBreakMode: lineBreakMode
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

        if let alignment {
            paragraphStyle.alignment = alignment
        }

        if let lineBreakMode {
            paragraphStyle.lineBreakMode = lineBreakMode
        }

        return paragraphStyle
    }

    private func resolveAttributes(paragraphStyle: NSParagraphStyle?) -> [NSAttributedString.Key: Any] {
        let font = font.uiFont

        var attributes: [NSAttributedString.Key: Any] = [
            .font: font
        ]

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

        return attributes
    }
}

extension TypographyValue: Changeable {

    public init(copy: ChangeableWrapper<Self>) {
        self.init(
            font: copy.font,
            letterSpacing: copy.letterSpacing,
            lineHeight: copy.lineHeight,
            paragraphSpacing: copy.paragraphSpacing,
            paragraphFirstLineIndent: copy.paragraphFirstLineIndent,
            paragraphOtherLineIndent: copy.paragraphOtherLineIndent,
            alignment: copy.alignment,
            foregroundColor: copy.foregroundColor,
            backgroundColor: copy.backgroundColor,
            stroke: copy.stroke,
            strikethrough: copy.strikethrough,
            underline: copy.underline,
            lineBreakMode: copy.lineBreakMode
        )
    }

    public func fontScale(_ fontScale: FontScaleValue?) -> Self {
        changing { $0.font = font.scale(fontScale) }
    }

    public func fontSize(_ fontSize: CGFloat) -> Self {
        changing { $0.font = font.size(fontSize) }
    }

    public func letterSpacing(_ letterSpacing: CGFloat?) -> Self {
        changing { $0.letterSpacing = letterSpacing }
    }

    public func lineHeight(_ lineHeight: CGFloat?) -> Self {
        changing { $0.lineHeight = lineHeight }
    }

    public func paragraphSpacing(_ paragraphSpacing: CGFloat?) -> Self {
        changing { $0.paragraphSpacing = paragraphSpacing }
    }

    public func paragraphFirstLineIndent(_ paragraphFirstLineIndent: CGFloat?) -> Self {
        changing { $0.paragraphFirstLineIndent = paragraphFirstLineIndent }
    }

    public func paragraphOtherLineIndent(_ paragraphOtherLineIndent: CGFloat?) -> Self {
        changing { $0.paragraphOtherLineIndent = paragraphOtherLineIndent }
    }

    public func alignment(_ alignment: NSTextAlignment?) -> Self {
        changing { $0.alignment = alignment }
    }

    public func foregroundColor(_ foregroundColor: ColorValue?) -> Self {
        changing { $0.foregroundColor = foregroundColor }
    }

    public func backgroundColor(_ backgroundColor: ColorValue?) -> Self {
        changing { $0.backgroundColor = backgroundColor }
    }

    public func stroke(_ stroke: TypographyStrokeValue?) -> Self {
        changing { $0.stroke = stroke }
    }

    public func strikethrough(_ strikethrough: TypographyLineValue?) -> Self {
        changing { $0.strikethrough = strikethrough }
    }

    public func underline(_ underline: TypographyLineValue?) -> Self {
        changing { $0.underline = underline }
    }

    public func lineBreakMode(_ lineBreakMode: NSLineBreakMode?) -> Self {
        changing { $0.lineBreakMode = lineBreakMode }
    }
}
#endif
