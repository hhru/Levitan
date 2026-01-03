import Levitan
import SwiftUI

struct ChatOutgoingMessage: Equatable, Sendable {

    let text: String
    let time: Date

    let isLast: Bool

    @ViewAction
    var tapAction: (@MainActor () -> Void)?

    @ViewState
    private var isPressed = false
}

extension ChatOutgoingMessage: Component {

    var body: some View {
        HStack(spacing: .zero) {
            Spacer(minLength: 32.0)

            ChatMessageContent(
                text: text,
                textColor: Colors.text.contrast,
                time: time,
                timeColor: Colors.text.contrast
            )
            .background(Colors.chat.outgoingMessage)
            .corners(
                radius: 12.0,
                mask: isLast
                    ? [.topLeft, .topRight, .bottomLeft]
                    : .all
            )
            .padding(.trailing, 12.0)
            .onTap(tapAction)
            .onPress { isPressed = $0 && tapAction != nil }
            .pressedEffect(
                isPressed,
                anchor: isLast ? .bottomTrailing : .trailing
            )
        }
    }

    func sizing(fitting size: CGSize, context: ComponentContext) -> ComponentSizing {
        ComponentSizing(width: .fill, height: .hug(forced: true))
    }
}

#Preview {
    ChatOutgoingMessage(
        text: """
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. \
            Phasellus id varius sem, at aliquam metus.
            """,
        time: Date(),
        isLast: true,
        tapAction: { print("Tapped") }
    )
}
