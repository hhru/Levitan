import Levitan
import SwiftUI

struct ChatIncomingMessage: Equatable, Sendable {

    let text: String
    let time: Date

    let isLast: Bool

    @ViewAction
    var tapAction: (@MainActor () -> Void)?

    @ViewState
    private var isPressed = false
}

extension ChatIncomingMessage: Component {

    var body: some View {
        HStack(spacing: .zero) {
            ChatMessageContent(
                text: text,
                textColor: Colors.text.primary,
                time: time,
                timeColor: Colors.text.secondary
            )
            .background(Colors.chat.incomingMessage)
            .corners(
                radius: 12.0,
                mask: isLast
                ? [.topLeft, .topRight, .bottomRight]
                : .all
            )
            .padding(.leading, 12.0)
            .onTap(tapAction)
            .onPress { isPressed = $0 && tapAction != nil }
            .pressedEffect(
                isPressed,
                anchor: isLast ? .bottomLeading : .leading
            )

            Spacer(minLength: 32.0)
        }
    }

    func sizing(fitting size: CGSize, context: ComponentContext) -> ComponentSizing {
        ComponentSizing(width: .fill, height: .hug(forced: true))
    }
}

#Preview {
    ChatIncomingMessage(
        text: """
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. \
            Phasellus id varius sem, at aliquam metus.
            """,
        time: Date(),
        isLast: true,
        tapAction: { print("Tapped") }
    )
}
