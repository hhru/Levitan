import Levitan
import SwiftUI

struct ChatHeader: Equatable, Sendable {

    let date: Date
    let info: String?

    @ViewAction
    var tapAction: (@MainActor () -> Void)?

    @ViewState
    private var isPressed = false
}

extension ChatHeader: View {

    var body: some View {
        VStack(spacing: .zero) {
            Text(DateFormatter.dayTextualMonthYear.string(from: date))
                .typography(Typographies.label4)
                .foregroundColor(Colors.text.tertiary)
                .alignment(.center)

            if let info {
                Text(info)
                    .typography(Typographies.label4)
                    .foregroundColor(Colors.text.tertiary)
                    .alignment(.center)
            }
        }
        .padding(.horizontal, info == nil ? 12.0 : 16.0)
        .padding(.vertical, info == nil ? 4.0 : 8.0)
        .clipShape(ShapeToken.capsule)
        .stroke(Strokes.stroke1.color(Colors.stroke))
        .backgroundColor(Colors.background.default)
        .onTap(tapAction)
        .onPress { isPressed = $0 && tapAction != nil }
        .pressedEffect(isPressed)
        .frame(maxWidth: .infinity)
    }
}

#Preview {

    ChatHeader(
        date: Date(),
        info: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus id varius sem, at aliquam metus.",
        tapAction: { print("Tapped") }
    )
}
