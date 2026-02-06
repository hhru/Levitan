import Foundation
import Levitan

struct ThemeColors: Sendable {

    struct Background: Sendable {

        /// Ligth: #FFFFFF
        /// Dark: #000000
        let `default`: ColorValue

        /// Ligth: #DCE3EBCC
        /// Dark: #FFFFFF19
        let pressed: ColorValue
    }

    struct Text: Sendable {

        /// Ligth: #000000
        /// Dark: #FFFFFF
        let primary: ColorValue

        /// Ligth: #768694
        /// Dark: #ABABAB
        let secondary: ColorValue

        /// Ligth: #AABBCA
        /// Dark: #767676
        let tertiary: ColorValue

        /// Ligth: #FFFFFF
        /// Dark: #FFFFFF
        let contrast: ColorValue
    }

    struct Tag: Sendable {

        /// Ligth: #000000
        /// Dark: #FFFFFF
        let label: ColorValue

        /// Ligth: #F1F4F9
        /// Dark: #303030
        let background: ColorValue
    }

    struct Chat: Sendable {

        /// Ligth: #F8F8F8
        /// Dark: #262626
        let incomingMessageBackground: ColorValue

        /// Ligth: #F1F1F1
        /// Dark: #303030
        let incomingMessageStroke: ColorValue

        /// Ligth: #0070FF
        /// Dark: #2B7FFF
        let outgoingMessageBackground: ColorValue

        /// Ligth: #0D63E3
        /// Dark: #0070FF
        let outgoingMessageStroke: ColorValue
    }

    let background: Background
    let text: Text
    let tag: Tag
    let chat: Chat

    /// Ligth: #0070FF
    /// Dark: #5E9EFF
    let accent: ColorValue

    /// Ligth: #DCE3EB
    /// Dark: #303030
    let stroke: ColorValue
}
