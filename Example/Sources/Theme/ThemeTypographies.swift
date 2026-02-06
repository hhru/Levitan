import Foundation
import Levitan

struct ThemeTypographies: Sendable {

    let title3 = TypographyToken(
        font: .system(weight: .semibold, size: 28.0),
        letterSpacing: -0.35,
        lineHeight: 40.0
    )

    let title4 = TypographyToken(
        font: .system(weight: .semibold, size: 22.0),
        letterSpacing: -0.16,
        lineHeight: 32.0
    )

    let title5 = TypographyToken(
        font: .system(weight: .semibold, size: 18.0),
        letterSpacing: 0.0,
        lineHeight: 26.0
    )

    let label2 = TypographyToken(
        font: .system(weight: .regular, size: 16.0),
        letterSpacing: 0.0,
        lineHeight: 22.0
    )

    let label3 = TypographyToken(
        font: .system(weight: .regular, size: 14.0),
        letterSpacing: 0.07,
        lineHeight: 16.0
    )

    let label4 = TypographyToken(
        font: .system(weight: .regular, size: 12.0),
        letterSpacing: 0.12,
        lineHeight: 18.0
    )

    let paragraph2 = TypographyToken(
        font: .system(weight: .regular, size: 16.0),
        letterSpacing: 0.08,
        lineHeight: 26.0
    )
}
