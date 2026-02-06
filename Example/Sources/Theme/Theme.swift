import Foundation
import Levitan

// swiftlint:disable identifier_name
let Colors = Theme.tokens.colors
let Typographies = Theme.tokens.typographies
let Strokes = Theme.tokens.strokes
let Animations = Theme.tokens.animations
// swiftlint:enable identifier_name

final class Theme: TokenThemeBody, Sendable {

    let colors: ThemeColors
    let typographies: ThemeTypographies
    let strokes: ThemeStrokes
    let animations: ThemeAnimations

    init(
        colors: ThemeColors,
        typographies: ThemeTypographies,
        strokes: ThemeStrokes,
        animations: ThemeAnimations
    ) {
        self.colors = colors
        self.typographies = typographies
        self.strokes = strokes
        self.animations = animations
    }
}
