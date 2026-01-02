import Levitan
import SwiftUI
import UIKit

final class UserListViewController: UIViewController {

    private let flowView = VerticalFlow.UIView()

    private var users = User.all {
        didSet { updateFlowView() }
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

    private func updateFlowView() {
        let context = ComponentContext
            .default
            .componentViewController(self)
            .fallbackComponentSizeCache(FallbackComponentSizeCache())

        let items = users.map { user in
            Cell(
                avatar: Avatar(
                    url: user.photoURL,
                    placeholder: Image(.avatarPlaceholder),
                    size: .small
                ),
                title: user.fullName,
                subtitle: user.position,
                action: CellAction(
                    title: "Edit",
                    action: { [weak self] in
                        self?.onUserActionTap()
                    }
                ),
                divider: user.id == users.last?.id ? nil : CellDivider(),
                tapAction: { [weak self] in
                    self?.onUserTap()
                }
            )
            .flowItem(identifier: user.id)
        }

        let flow = VerticalFlow(items: items)

        flowView.update(
            with: flow,
            context: context
        )
    }

    private func onUserActionTap() {
    }

    private func onUserTap() {
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupFlowView()
        updateFlowView()
    }
}
