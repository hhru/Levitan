import Foundation
import Levitan

struct ChatMessage: Changeable, Hashable, Sendable {

    let id = UUID()

    let type: ChatMessageType
    var text: String
    var date: Date
}
