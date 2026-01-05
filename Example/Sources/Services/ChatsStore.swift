import Combine
import Foundation

@MainActor
final class ChatsStore {

    private let chatsSubject = CurrentValueSubject<[Chat], Never>(Chat.all)

    private init() { }
}

extension ChatsStore {

    static let shared = ChatsStore()

    var chats: [Chat] {
        chatsSubject.value
    }

    var chatsPublisher: AnyPublisher<[Chat], Never> {
        chatsSubject.eraseToAnyPublisher()
    }

    func chat(userID: Int) -> Chat? {
        chats.first { $0.userID == userID }
    }

    func chatIndex(userID: Int) -> Int? {
        chats.firstIndex { $0.userID == userID }
    }

    func updateChats(with chats: [Chat]) {
        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)

            chatsSubject.send(chats)
        }
    }

    func updateChat(userID: Int, with closure: (inout Chat) -> Void) {
        let chats = chats.changing { chats in
            if let index = chatIndex(userID: userID) {
                closure(&chats[index])
            } else {
                var chat = Chat(userID: userID)

                closure(&chat)

                chats.insert(chat, at: .zero)
            }
        }

        updateChats(with: chats)
    }

    func updateChat(userID: Int, isPinned: Bool) {
        updateChat(userID: userID) { $0.isPinned = isPinned }
    }

    func removeChat(userID: Int) {
        updateChats(with: chats.filter { $0.userID != userID })
    }

    func insertChatMessage(userID: Int, message: ChatMessage) {
        updateChat(userID: userID) { chat in
            chat.messages.append(message)
            chat.messages.sort { $0.date < $1.date }
        }
    }

    func insertChatIncomingMessage(userID: Int, text: String, date: Date) {
        let message = ChatMessage(
            type: .incoming,
            text: text,
            date: date
        )

        insertChatMessage(userID: userID, message: message)
    }

    func insertChatOutgoingMessage(userID: Int, text: String, date: Date) {
        let message = ChatMessage(
            type: .outgoing,
            text: text,
            date: date
        )

        insertChatMessage(userID: userID, message: message)
    }

    func updateChatMessage(userID: Int, messageID: UUID, text: String) {
        updateChat(userID: userID) { chat in
            if let index = chat.messageIndex(id: messageID) {
                chat.messages[index].text = text
            }
        }
    }

    func removeChatMessage(userID: Int, messageID: UUID) {
        updateChat(userID: userID) { chat in
            chat.messages.removeAll { $0.id == messageID }
        }
    }
}
