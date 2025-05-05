import SwiftUI

internal struct TextContent: Sendable, Hashable {

    internal let parts: [AnyTextPart]

    internal var typography: TypographyToken?
    internal var decoration: [AnyTextDecorator]
    internal var animation: TextAnimation?

    internal var lineLimit: Int?
    internal var lineBreakMode: NSLineBreakMode

    internal var isEnabled: Bool

    @ViewAction
    internal var tapAction: (@MainActor () -> Void)?
}
