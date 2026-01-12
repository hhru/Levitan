import Combine
import Levitan
import SwiftUI
import UIKit

final class ChatsViewController: UIViewController {

    private let chatsStore = ChatsStore.shared
    private var chatsSubscription: AnyCancellable?

    private let usersStore = UsersStore.shared
    private var usersSubscription: AnyCancellable?

    private var context = ComponentContext.default

    private let contentView = VFlow.UIView()
    private let searchController = UISearchController(searchResultsController: nil)

    private var searchText = "" {
        didSet { updateContentView() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.tokens.backgroundColor = Colors.background.default

        context = context
            .componentViewController(self)
            .fallbackComponentCache(FallbackComponentCache())
            .textCache(TextCache())

        setupNavigationBar()
        setupSearchController()
        setupContentView()

        usersSubscription = usersStore
            .usersPublisher
            .sink { [weak self] _ in
                self?.updateContentView()
            }

        chatsSubscription = chatsStore
            .chatsPublisher
            .sink { [weak self] _ in
                self?.updateContentView()
            }
    }
}

extension ChatsViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        searchText = searchController.searchBar.text ?? ""
    }
}

extension ChatsViewController {

    private func setupNavigationBar() {
        navigationItem.title = "Chats"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Reset",
            style: .plain,
            target: self,
            action: #selector(onResetChatsTap)
        )
    }

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.tokens.tintColor = Colors.accent

        definesPresentationContext = true
    }

    private func setupContentView() {
        view.addSubview(contentView)

        contentView.contentInsetAdjustmentBehavior = .always
        contentView.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    private func updateContentView() {
        let searchText = searchText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        var chats = chatsStore
            .chats
            .filter { !$0.messages.isEmpty }
            .sorted { lhs, rhs in
                let lhsDate = lhs.messages.last?.date ?? Date()
                let rhsDate = rhs.messages.last?.date ?? Date()

                return lhs.isPinned == rhs.isPinned
                    ? lhsDate > rhsDate
                    : lhs.isPinned && !rhs.isPinned
            }

        if !searchText.isEmpty {
            chats.removeAll { chat in
                usersStore
                    .user(id: chat.userID)?
                    .name
                    .lowercased()
                    .contains(searchText) != true
            }
        }

        let content = VFlow {
            chatSection(chats: chats)
        }
        .scrollAlwaysBounces()

        contentView.update(
            with: content,
            context: context
        )
    }
}

extension ChatsViewController {

    private func chatSection(chats: [Chat]) -> VFlowSection? {
        guard !chats.isEmpty else {
            return nil
        }

        return VFlowSection(identifier: #function) {
            chats.enumerated().map { index, chat in
                chatItem(chat: chat, isLast: index >= chats.count - 1)
            }
        }
    }

    private func chatItem(chat: Chat, isLast: Bool) -> any FlowItem {
        let user = usersStore.user(id: chat.userID)
        let lastMessage = chat.messages.last?.text

        return Cell(
            avatar: Avatar(
                url: user?.photoURL,
                placeholder: Image(.avatarPlaceholder),
                size: .small
            ),
            title: user?.name ?? "Unknown user",
            subtitle: lastMessage ?? "",
            action: CellAction(
                title: "Edit",
                action: { [weak self] in
                    self?.onEditChatTap(userID: chat.userID)
                }
            ),
            divider: !isLast,
            tapAction: { [weak self] in
                self?.onChatTap(userID: chat.userID)
            }
        )
        .flowItem(identifier: chat.userID)
    }
}

extension ChatsViewController {

    @objc private func onResetChatsTap() {
        chatsStore.updateChats(with: Chat.all)
    }

    private func onChatTap(userID: Int) {
        navigationController?.pushViewController(
            ChatViewController(userID: userID),
            animated: true
        )
    }

    private func onEditChatTap(userID: Int) {
        guard let chat = chatsStore.chat(userID: userID) else {
            return
        }

        let actionSheet = ActionSheet {
            if chat.isPinned {
                ActionSheetAction(title: "Unpin сhat") {
                    self.chatsStore.updateChat(userID: userID, isPinned: false)
                }
            } else {
                ActionSheetAction(title: "Pin chat") {
                    self.chatsStore.updateChat(userID: userID, isPinned: true)
                }
            }

            ActionSheetAction(title: "Remove chat", style: .destructive) {
                self.chatsStore.removeChat(userID: userID)
            }

            ActionSheetAction.cancel(title: "Cancel")
        }

        showActionSheet(actionSheet)
    }
}
