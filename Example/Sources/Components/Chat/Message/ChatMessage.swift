import Levitan
import SwiftUI

struct ChatMessage: Equatable, Sendable {

    let text: String
    let textColor: ColorToken

    let time: Date
    let timeColor: ColorToken
}

extension ChatMessage: View {

    var body: some View {
        VStack(alignment: .trailing, spacing: 2.0) {
            Text(text)
                .typography(Typographies.label3)
                .foregroundColor(textColor)

            Text(DateFormatter.hoursMinutes.string(from: time))
                .typography(Typographies.label4)
                .foregroundColor(timeColor)
        }
        .padding(8.0)
        .contentShape(Rectangle())
    }
}

#Preview {
    ChatMessage(
        text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus id varius sem, at aliquam metus.",
        textColor: Colors.text.contrast,
        time: Date(),
        timeColor: Colors.text.contrast
    )
    .backgroundColor(Colors.chat.outgoingMessage)
}
