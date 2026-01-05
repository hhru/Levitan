import Combine
import Levitan
import SwiftUI
import UIKit

final class ContactsViewController: UIViewController {

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

        definesPresentationContext = true

        setupNavigationBar()
        setupSearchController()

        setupFlowView()
        setupFlowContext()

        usersSubscription = usersStore
            .usersPublisher
            .sink { [weak self] _ in
                self?.updateFlowView()
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

        let flow = VerticalFlow {
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

        flowView.update(with: flow, context: flowContext)
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
            ActionSheetAction(title: "Remove user", style: .destructive) {
                self.usersStore.removeUser(id: userID)
            }

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

            ActionSheetAction.cancel(title: "Cancel")
        }

        showActionSheet(actionSheet)
    }

    private func onEditUserNameTap(userID: Int) {
        let name = usersStore.user(id: userID)?.name ?? ""

        let textField = AlertTextField(
            text: name,
            placeholder: "Name"
        )

        let alert = Alert(title: "User name", textFields: [textField]) {
            AlertAction(title: "Save") { texts in
                self.usersStore.updateUser(id: userID, name: texts.first ?? "")
            }

            AlertAction(title: "Reset", style: .destructive) {
                self.usersStore.updateUser(id: userID, name: "")
            }

            AlertAction.cancel(title: "Cancel")
        }

        showAlert(alert)
    }

    private func onEditUserDescriptionTap(userID: Int) {
        let description = usersStore.user(id: userID)?.description ?? ""

        let textField = AlertTextField(
            text: description,
            placeholder: "Description"
        )

        let alert = Alert(title: "User description", textFields: [textField]) {
            AlertAction(title: "Save") { texts in
                self.usersStore.updateUser(id: userID, description: texts.first ?? "")
            }

            AlertAction(title: "Reset", style: .destructive) {
                self.usersStore.updateUser(id: userID, description: "")
            }

            AlertAction.cancel(title: "Cancel")
        }

        showAlert(alert)
    }

    private func onEditUserRatingTap(userID: Int) {
        let rating = usersStore.user(id: userID)?.rating ?? .zero

        let textField = AlertTextField(
            text: String(rating),
            placeholder: "Rating"
        )

        let alert = Alert(title: "User rating", textFields: [textField]) {
            AlertAction(title: "Save") { texts in
                self.usersStore.updateUser(
                    id: userID,
                    rating: texts.first.flatMap { Int($0) } ?? .zero
                )
            }

            AlertAction(title: "Reset", style: .destructive) {
                self.usersStore.updateUser(id: userID, rating: .zero)
            }

            AlertAction.cancel(title: "Cancel")
        }

        showAlert(alert)
    }
}
