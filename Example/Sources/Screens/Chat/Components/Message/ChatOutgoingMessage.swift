import Levitan
import SwiftUI

struct ChatOutgoingMessage: Equatable, Sendable {

    let text: String
    let time: Date

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
            .background(Colors.chat.outgoingMessageBackground)
            .corners(
                radius: 12.0,
                mask: [.topLeft, .topRight, .bottomLeft]
            )
            .stroke(Strokes.stroke1.color(Colors.chat.outgoingMessageStroke))
            .onTap(tapAction)
            .onPress { isPressed = $0 && tapAction != nil }
            .pressedEffect(isPressed, anchor: .bottomTrailing)
            .padding(.trailing, 12.0)
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
        tapAction: { print("Tapped") }
    )
}
