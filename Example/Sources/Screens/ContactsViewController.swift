import Combine
import Levitan
import SwiftUI
import UIKit

final class ContactsViewController: UIViewController {

    private let usersStore = UsersStore.shared
    private var usersSubscription: AnyCancellable?

    private var context = ComponentContext.default

    private let searchController = UISearchController(searchResultsController: nil)
    private let contentView = VerticalFlow.UIView()

    private var searchText = "" {
        didSet { updateContentView() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.tokens.backgroundColor = Colors.background.default

        context = context
            .componentViewController(self)
            .fallbackComponentSizeCache(FallbackComponentSizeCache())
            .textCache(TextCache())

        setupNavigationBar()
        setupSearchController()
        setupContentView()

        usersSubscription = usersStore
            .usersPublisher
            .sink { [weak self] _ in
                self?.updateContentView()
            }
    }
}

extension ContactsViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        searchText = searchController.searchBar.text ?? ""
    }
}

extension ContactsViewController {

    private func setupNavigationBar() {
        navigationItem.title = "Users"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Reset",
            style: .plain,
            target: self,
            action: #selector(onResetUsersTap)
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

        var users = usersStore
            .users
            .sorted { $0.rating > $1.rating }

        if !searchText.isEmpty {
            users.removeAll { user in
                !user
                    .name
                    .lowercased()
                    .contains(searchText)
            }
        }

        let content = VerticalFlow {
            if searchText.isEmpty {
                userSection(
                    title: "Favorites",
                    users: users.filter { $0.isFavorite }
                )

                userSection(
                    title: "Other",
                    users: users.filter { !$0.isFavorite }
                )
            } else {
                userSection(users: users)
            }
        }
        .scrollAlwaysBounces()

        contentView.update(
            with: content,
            context: context
        )
    }
}

extension ContactsViewController {

    private func userSection(title: String? = nil, users: [User]) -> VerticalFlowSection? {
        guard !users.isEmpty else {
            return nil
        }

        let items = users.enumerated().map { index, user in
            userItem(user: user, isLast: index >= users.count - 1)
        }

        let header = title.map { title in
            Text(title)
                .typography(Typographies.label2)
                .foregroundColor(Colors.text.secondary)
                .padding(top: 20.0, leading: 16.0, bottom: 8.0, trailing: 16.0)
                .flowHeader()
        }

        return VerticalFlowSection(
            identifier: title,
            items: items,
            header: header
        )
    }

    private func userItem(user: User, isLast: Bool) -> any FlowItem {
        Cell(
            avatar: Avatar(
                url: user.photoURL,
                placeholder: Image(.avatarPlaceholder),
                size: .small
            ),
            title: user.name,
            subtitle: user.description,
            action: CellAction(
                title: "Edit",
                action: { [weak self] in
                    self?.onEditUserTap(userID: user.id)
                }
            ),
            divider: !isLast,
            tapAction: { [weak self] in
                self?.onUserTap(userID: user.id)
            }
        )
        .flowItem(identifier: user.id)
    }
}

extension ContactsViewController {

    @objc private func onResetUsersTap() {
        usersStore.updateUsers(with: User.all)
    }

    private func onUserTap(userID: Int) {
        navigationController?.pushViewController(
            ChatViewController(userID: userID),
            animated: true
        )
    }

    private func onEditUserTap(userID: Int) {
        guard let user = usersStore.user(id: userID) else {
            return
        }

        let actionSheet = ActionSheet(title: user.name) {
            ActionSheetAction(title: "Edit user name") {
                self.onEditUserNameTap(userID: userID)
            }

            ActionSheetAction(title: "Edit user description") {
                self.onEditUserDescriptionTap(userID: userID)
            }

            ActionSheetAction(title: "Edit user rating") {
                self.onEditUserRatingTap(userID: userID)
            }

            if user.isFavorite {
                ActionSheetAction(title: "Remove from Favorites") {
                    self.usersStore.updateUser(id: userID, isFavorite: false)
                }
            } else {
                ActionSheetAction(title: "Add to Favorites") {
                    self.usersStore.updateUser(id: userID, isFavorite: true)
                }
            }

            ActionSheetAction(title: "Remove user", style: .destructive) {
                self.usersStore.removeUser(id: userID)
            }

            ActionSheetAction.cancel(title: "Cancel")
        }

        showActionSheet(actionSheet)
    }

    private func onEditUserNameTap(userID: Int) {
        let name = usersStore.user(id: userID)?.name

        let alert = Alert.textEditor(
            title: "User name",
            text: name,
            placeholder: "Name",
            saveAction: { name in
                self.usersStore.updateUser(
                    id: userID,
                    name: name
                )
            }
        )

        showAlert(alert)
    }

    private func onEditUserDescriptionTap(userID: Int) {
        let description = usersStore.user(id: userID)?.description

        let alert = Alert.textEditor(
            title: "User description",
            text: description,
            placeholder: "Description",
            saveAction: { description in
                self.usersStore.updateUser(
                    id: userID,
                    description: description
                )
            }
        )

        showAlert(alert)
    }

    private func onEditUserRatingTap(userID: Int) {
        let rating = usersStore.user(id: userID)?.rating ?? .zero

        let alert = Alert.textEditor(
            title: "User rating",
            text: String(rating),
            placeholder: "Rating",
            saveAction: { rating in
                self.usersStore.updateUser(
                    id: userID,
                    rating: Int(rating) ?? .zero
                )
            }
        )

        showAlert(alert)
    }
}
