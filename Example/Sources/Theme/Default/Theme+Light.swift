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
                contrast: 0xFFFFFFFF
            ),
            tag: ThemeColors.Tag(
                label: 0x000000FF,
                background: 0xF1F4F9FF
            ),
            chat: ThemeColors.Chat(
                incomingMessageBackground: 0xF8F8F8FF,
                incomingMessageStroke: 0xF1F1F1FF,
                outgoingMessageBackground: 0x0070FFFF,
                outgoingMessageStroke: 0x0D63E3FF
            ),
            accent: 0x0070FFFF,
            stroke: 0xDCE3EBFF
        ),
        typographies: ThemeTypographies(),
        strokes: ThemeStrokes(),
        animations: ThemeAnimations()
    )
}
