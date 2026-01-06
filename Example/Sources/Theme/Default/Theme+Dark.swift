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
                contrast: 0xFFFFFFFF
            ),
            tag: ThemeColors.Tag(
                label: 0xFFFFFFFF,
                background: 0x303030FF
            ),
            chat: ThemeColors.Chat(
                incomingMessageBackground: 0x262626FF,
                incomingMessageStroke: 0x303030FF,
                outgoingMessageBackground: 0x2B7FFFFF,
                outgoingMessageStroke: 0x0070FFFF
            ),
            accent: 0x5E9EFFFF,
            stroke: 0x303030FF
        ),
        typographies: ThemeTypographies(),
        strokes: ThemeStrokes(),
        animations: ThemeAnimations()
    )
}
