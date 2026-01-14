import Foundation
import Levitan

struct ChatMessage: Changeable, Identifiable, Hashable, Sendable {

    let id = UUID()

    let type: ChatMessageType
    var text: String
    var date: Date
}
