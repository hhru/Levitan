import Foundation
import Levitan
import SwiftUI

struct ChatInput: Sendable {

    @ViewBinding
    var text: String

    @ViewAction
    var sendAction: @MainActor () -> Void
}

extension ChatInput: FallbackComponent {

    typealias UIView = ChatInputView
}

#Preview {
    ChatInput(
        text: .constant("Text "),
        sendAction: { print("Tapped") }
    )
    .padding(all: 16.0)
}
