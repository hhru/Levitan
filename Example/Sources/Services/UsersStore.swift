import Combine
import Foundation

@MainActor
final class UsersStore {

    private let usersSubject = CurrentValueSubject<[User], Never>(User.all)

    private init() { }
}

extension UsersStore {

    static let shared = UsersStore()

    var users: [User] {
        usersSubject.value
    }

    var usersPublisher: AnyPublisher<[User], Never> {
        usersSubject.eraseToAnyPublisher()
    }

    func user(id: Int) -> User? {
        users.first { $0.id == id }
    }

    func userIndex(id: Int) -> Int? {
        users.firstIndex { $0.id == id }
    }

    func updateUsers(with users: [User]) {
        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)

            usersSubject.send(users)
        }
    }

    func updateUser(id: Int, with closure: (inout User) -> Void) {
        guard let index = userIndex(id: id) else {
            return
        }

        let users = users.changing { users in
            closure(&users[index])
        }

        updateUsers(with: users)
    }

    func updateUser(id: Int, name: String) {
        updateUser(id: id) { $0.name = name }
    }

    func updateUser(id: Int, description: String) {
        updateUser(id: id) { $0.description = description }
    }

    func updateUser(id: Int, rating: Int) {
        updateUser(id: id) { $0.rating = rating }
    }

    func updateUser(id: Int, isFavorite: Bool) {
        updateUser(id: id) { $0.isFavorite = isFavorite }
    }

    func removeUser(id: Int) {
        updateUsers(with: users.filter { $0.id != id })
    }
}
