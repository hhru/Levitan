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
        guard let index = chatIndex(userID: userID) else {
            return
        }

        let chats = chats.changing { chats in
            closure(&chats[index])
        }

        updateChats(with: chats)
    }

    func updateChat(userID: Int, isPinned: Bool) {
        updateChat(userID: userID) { $0.isPinned = isPinned }
    }

    func removeChat(userID: Int) {
        updateChats(with: chats.filter { $0.userID != userID })
    }
}
