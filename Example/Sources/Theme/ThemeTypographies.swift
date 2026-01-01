import Foundation
import Levitan

struct ThemeTypographies: Sendable {

    let label2 = TypographyToken(
        font: .system(weight: .regular, size: 16.0),
        letterSpacing: 0.0,
        lineHeight: 22.0
    )

    let label3 = TypographyToken(
        font: .system(weight: .regular, size: 14.0),
        letterSpacing: 0.07,
        lineHeight: 20.0
    )

    let label4 = TypographyToken(
        font: .system(weight: .regular, size: 12.0),
        letterSpacing: 0.12,
        lineHeight: 18.0
    )
}
