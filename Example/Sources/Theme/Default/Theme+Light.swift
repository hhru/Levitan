import Foundation
import Levitan

extension Theme {

    static let defaultLight = Theme(
        colors: ThemeColors(
            background: ThemeColors.Background(
                default: 0xFFFFFFFF,
                pressed: 0xDCE3EBCC
            ),
            text: ThemeColors.Text(
                primary: 0x000000FF,
                secondary: 0x768694FF,
                tertiary: 0xAABBCAFF,
                accent: 0x0070FFFF,
                contrast: 0xFFFFFFFF
            ),
            chat: ThemeColors.Chat(
                incomingMessage: 0xF8F8F8FF,
                outgoingMessage: 0x0070FFFF
            ),
            stroke: 0xDCE3EBFF
        ),
        typographies: ThemeTypographies(),
        strokes: ThemeStrokes(),
        animations: ThemeAnimations()
    )
}
