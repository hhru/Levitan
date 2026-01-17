import Levitan
import SwiftUI
import UIKit

final class PerformanceViewController: UIViewController {

    private let usersStore = UsersStore.shared

    private var context = ComponentContext.default
    private let contentView = VFlow.UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.tokens.backgroundColor = Colors.background.default

        context = context
            .componentViewController(self)
            .fallbackComponentCache(FallbackComponentCache())
            .textCache(TextCache())

        setupNavigationBar()
        setupContentView()

        updateContentView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        PerformanceTracker.shared.start()
        PerformanceTracker.shared.showMonitor()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.scrollToNextUser(after: .zero)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        PerformanceTracker.shared.hideMonitor()
        PerformanceTracker.shared.stop()
    }
}

extension PerformanceViewController {

    private func setupNavigationBar() {
        navigationItem.title = "Users"
    }

    private func setupContentView() {
        view.addSubview(contentView)

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
        let users = usersStore.users

        let content = VFlow(
            itemsData: Array(users.enumerated()),
            itemsID: \.element.id,
            items: { index, user in
                userItem(
                    user: user,
                    isLast: index >= users.count - 1
                )
            }
        )
        .contentMarginsAdjustmentBehavior(.always)
        .scrollAlwaysBounces()

        contentView.update(
            with: content,
            context: context
        )
    }

    private func scrollToNextUser(after userIndex: Int) {
        guard userIndex < usersStore.users.count - 1 else {
            return
        }

        let nextUserIndex = min(userIndex + 5, usersStore.users.count - 1)
        let nextUser = usersStore.users[nextUserIndex]

        contentView.scrollToItem(
            where: { $0.id == nextUser.id as AnyHashable },
            anchor: .top
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.scrollToNextUser(after: nextUserIndex)
        }
    }
}

extension PerformanceViewController {

    private func userItem(user: User, isLast: Bool) -> any Component {
        Cell(
            avatar: Avatar(
                url: nil,
                placeholder: Image(.avatarPlaceholder),
                size: .small
            ),
            title: user.name,
            subtitle: user.description,
            action: nil,
            divider: !isLast,
            tapAction: nil
        )
    }
}
