import Levitan
import SwiftUI

struct ChatIncomingMessage: Equatable, Sendable {

    let text: String
    let time: Date

    @ViewAction
    var tapAction: (@MainActor () -> Void)?

    @ViewState
    private var isPressed = false
}

extension ChatIncomingMessage: View {

    var body: some View {
        HStack(spacing: .zero) {
            ChatMessageContent(
                text: text,
                textColor: Colors.text.primary,
                time: time,
                timeColor: Colors.text.secondary
            )
            .background(Colors.chat.incomingMessageBackground)
            .corners(
                radius: 12.0,
                mask: [.topLeft, .topRight, .bottomRight]
            )
            .stroke(Strokes.inside.color(Colors.chat.incomingMessageStroke))
            .onTap(tapAction)
            .onPress { isPressed = $0 && tapAction != nil }
            .pressedEffect(isPressed, anchor: .bottomLeading)
            .padding(.leading, 12.0)

            Spacer(minLength: 32.0)
        }
    }
}

extension ChatIncomingMessage: Component {

    func sizing(fitting size: CGSize, context: ComponentContext) -> ComponentSizing {
        ComponentSizing(width: .fill, height: .hug)
    }
}

#Preview {
    ChatIncomingMessage(
        text: """
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. \
            Phasellus id varius sem, at aliquam metus.
            """,
        time: Date(),
        tapAction: { print("Tapped") }
    )
}
