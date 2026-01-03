import Foundation
import Levitan

extension Theme {

    static let defaultDark = Theme(
        colors: ThemeColors(
            background: ThemeColors.Background(
                default: 0x000000FF,
                pressed: 0xFFFFFF19
            ),
            text: ThemeColors.Text(
                primary: 0xFFFFFFFF,
                secondary: 0xABABABFF,
                tertiary: 0x767676FF,
                accent: 0x5E9EFFFF,
                contrast: 0xFFFFFFFF
            ),
            tag: ThemeColors.Tag(
                label: 0xFFFFFFFF,
                background: 0x303030FF
            ),
            chat: ThemeColors.Chat(
                incomingMessage: 0x262626FF,
                outgoingMessage: 0x2B7FFFFF
            ),
            stroke: 0x303030FF
        ),
        typographies: ThemeTypographies(),
        strokes: ThemeStrokes(),
        animations: ThemeAnimations()
    )
}
