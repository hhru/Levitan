import SwiftUI

internal struct TextContent: Sendable, Hashable {

    let parts: [AnyTextPart]

    var typography: TypographyToken?
    var decoration: [AnyTextDecorator]
    var animation: TextAnimation?

    var lineLimit: Int?
    var lineBreakMode: NSLineBreakMode

    var isEnabled: Bool

    @ViewAction
    var tapAction: (@MainActor () -> Void)?
}
