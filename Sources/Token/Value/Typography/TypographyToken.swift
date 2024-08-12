import UIKit

public typealias TypographyToken = Token<TypographyValue>

extension TypographyToken {

    public init(
        font: FontToken,
        letterSpacing: CGFloat? = nil,
        lineHeight: CGFloat? = nil,
        paragraphSpacing: CGFloat? = nil,
        paragraphFirstLineIndent: CGFloat? = nil,
        paragraphOtherLineIndent: CGFloat? = nil,
        alignment: NSTextAlignment? = nil,
        foregroundColor: ColorToken? = nil,
        backgroundColor: ColorToken? = nil,
        stroke: TypographyStrokeToken? = nil,
        strikethrough: TypographyLineToken? = nil,
        underline: TypographyLineToken? = nil
    ) {
        self = Token(
            traits: [
                font,
                letterSpacing,
                lineHeight,
                paragraphSpacing,
                paragraphFirstLineIndent,
                paragraphOtherLineIndent,
                alignment,
                foregroundColor,
                backgroundColor,
                stroke,
                strikethrough,
                underline
            ]
        ) { theme in
            Value(
                font: font.resolve(for: theme),
                letterSpacing: letterSpacing,
                lineHeight: lineHeight,
                paragraphSpacing: paragraphSpacing,
                paragraphFirstLineIndent: paragraphFirstLineIndent,
                paragraphOtherLineIndent: paragraphOtherLineIndent,
                alignment: alignment,
                foregroundColor: foregroundColor?.resolve(for: theme),
                backgroundColor: backgroundColor?.resolve(for: theme),
                stroke: stroke?.resolve(for: theme),
                strikethrough: strikethrough?.resolve(for: theme),
                underline: underline?.resolve(for: theme)
            )
        }
    }
}

extension TypographyToken {

    public init(
        fontWeight: FontWeightToken,
        fontSize: FontSizeToken,
        fontScale: FontScaleToken? = nil,
        letterSpacing: CGFloat? = nil,
        lineHeight: CGFloat? = nil,
        paragraphSpacing: CGFloat? = nil,
        paragraphFirstLineIndent: CGFloat? = nil,
        paragraphOtherLineIndent: CGFloat? = nil,
        alignment: NSTextAlignment? = nil,
        foregroundColor: ColorToken? = nil,
        backgroundColor: ColorToken? = nil,
        stroke: TypographyStrokeToken? = nil,
        strikethrough: TypographyLineToken? = nil,
        underline: TypographyLineToken? = nil
    ) {
        self.init(
            font: FontToken(
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
            underline: underline
        )
    }
}
