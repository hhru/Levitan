import Combine
import Levitan
import SwiftUI
import UIKit

final class ChatsViewController: UIViewController {

    private let chatsStore = ChatsStore.shared
    private var chatsSubscription: AnyCancellable?

    private let usersStore = UsersStore.shared
    private var usersSubscription: AnyCancellable?

    private let searchController = UISearchController(searchResultsController: nil)

    private let flowView = VerticalFlow.UIView()
    private var flowContext = ComponentContext.default

    private var searchText = "" {
        didSet { updateFlowView() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.tokens.backgroundColor = Colors.background.default

        setupNavigationBar()
        setupSearchController()
        setupFlowView()
        setupFlowContext()

        usersSubscription = usersStore
            .usersPublisher
            .sink { [weak self] _ in
                self?.updateFlowView()
            }

        chatsSubscription = chatsStore
            .chatsPublisher
            .sink { [weak self] _ in
                self?.updateFlowView()
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
        searchController.searchBar.tokens.tintColor = Colors.text.accent
    }

    private func setupFlowView() {
        view.addSubview(flowView)

        flowView.contentInsetAdjustmentBehavior = .always
        flowView.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            flowView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            flowView.topAnchor.constraint(equalTo: view.topAnchor),
            flowView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            flowView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    private func setupFlowContext() {
        flowContext = flowContext
            .componentViewController(self)
            .fallbackComponentSizeCache(FallbackComponentSizeCache())
    }

    private func updateFlowView() {
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

        let flow = VerticalFlow {
            chatSection(chats: chats)
        }

        flowView.update(with: flow, context: flowContext)
    }
}

extension ChatsViewController {

    private func chatSection(chats: [Chat]) -> VerticalFlowSection? {
        guard !chats.isEmpty else {
            return nil
        }

        return VerticalFlowSection(identifier: #function) {
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
        // TODO: открывать чат
    }

    private func onEditChatTap(userID: Int) {
        guard let chat = chatsStore.chat(userID: userID) else {
            return
        }

        let actionSheet = ActionSheet {
            // TODO: добавить действия
            ActionSheetAction.cancel(title: "Cancel")
        }

        showActionSheet(actionSheet)
    }
}
