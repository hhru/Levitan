import Levitan
import SwiftUI

struct ChatInputButton: Equatable, Sendable {

    @ViewAction
    var tapAction: @MainActor () -> Void

    @ViewEnvironment(\.isEnabled)
    private var isEnabled: Bool

    @ViewState
    private var isPressed = false
}

extension ChatInputButton: View {

    var body: some View {
        Image(systemName: "paperplane.fill")
            .resizable()
            .frame(width: 24.0, height: 24.0)
            .foregroundColor(Colors.accent)
            .padding(8.0)
            .onTap(tapAction)
            .onPress { isPressed = $0 }
            .pressedEffect(isPressed)
            .opacity(isEnabled ? 1.0 : 0.5)
    }
}

extension ChatInputButton: Component {

    func sizing(fitting size: CGSize, context: ComponentContext) -> ComponentSizing {
        ComponentSizing(width: .hug, height: .hug)
    }
}

#Preview {
    ChatInputButton(tapAction: { print("Tapped") })
}
