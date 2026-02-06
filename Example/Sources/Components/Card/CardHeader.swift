import Levitan
import SwiftUI

struct CardHeader: Equatable, Sendable {

    let title: String

    @ViewAction
    var editAction: (@MainActor () -> Void)?

    @ViewState
    private var isPressed = false
}

extension CardHeader: View {

    var body: some View {
        HStack(spacing: .zero) {
            Text(title)
                .typography(Typographies.title5)
                .foregroundColor(Colors.text.primary)

            Spacer(minLength: 12.0)

            if let editAction {
                Text("Edit")
                    .typography(Typographies.label2)
                    .foregroundColor(Colors.accent)
                    .onTap(editAction)
                    .onPress { isPressed = $0 }
                    .pressedEffect(isPressed)
                    .layoutPriority(1.0)
            }
        }
    }
}

#Preview {
    CardHeader(
        title: "About me",
        editAction: { print("Tapped") }
    )
}
