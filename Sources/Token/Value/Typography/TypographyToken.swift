import UIKit

public typealias TypographyToken = Token<TypographyValue>

extension TypographyToken {

    public init(
        font: FontToken,
        foregroundColor: ColorToken? = nil,
        backgroundColor: ColorToken? = nil,
        stroke: TypographyStrokeToken? = nil,
        strikethrough: TypographyLineToken? = nil,
        underline: TypographyLineToken? = nil,
        letterSpacing: CGFloat? = nil,
        paragraphSpacing: CGFloat? = nil,
        paragraphFirstLineIndent: CGFloat? = nil,
        paragraphOtherLineIndent: CGFloat? = nil,
        lineHeight: CGFloat? = nil,
        lineBreakMode: NSLineBreakMode? = nil,
        alignment: NSTextAlignment? = nil
    ) {
        self = Token(
            traits: [
                font,
                foregroundColor,
                backgroundColor,
                stroke,
                strikethrough,
                underline,
                letterSpacing,
                paragraphSpacing,
                paragraphFirstLineIndent,
                paragraphOtherLineIndent,
                lineHeight,
                lineBreakMode,
                alignment
            ]
        ) { theme in
            Value(
                font: font.resolve(for: theme),
                foregroundColor: foregroundColor?.resolve(for: theme),
                backgroundColor: backgroundColor?.resolve(for: theme),
                stroke: stroke?.resolve(for: theme),
                strikethrough: strikethrough?.resolve(for: theme),
                underline: underline?.resolve(for: theme),
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
}

extension TypographyToken {

    public init(
        fontWeight: FontWeightToken,
        fontSize: FontSizeToken,
        fontScale: FontScaleToken? = nil,
        foregroundColor: ColorToken? = nil,
        backgroundColor: ColorToken? = nil,
        stroke: TypographyStrokeToken? = nil,
        strikethrough: TypographyLineToken? = nil,
        underline: TypographyLineToken? = nil,
        letterSpacing: CGFloat? = nil,
        paragraphSpacing: CGFloat? = nil,
        paragraphFirstLineIndent: CGFloat? = nil,
        paragraphOtherLineIndent: CGFloat? = nil,
        lineHeight: CGFloat? = nil,
        lineBreakMode: NSLineBreakMode? = nil,
        alignment: NSTextAlignment? = nil
    ) {
        self.init(
            font: FontToken(
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
}
