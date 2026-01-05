import Foundation

struct ChatMessage: Hashable, Sendable {

    let id: Int
    let type: ChatMessageType
    let text: String
    let date: Date
}
