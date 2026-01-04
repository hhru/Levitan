import Levitan
import SwiftUI
import UIKit

final class UserListViewController: UIViewController {

    private let flowView = VerticalFlow.UIView()
    private let cellView = Cell.UIView()

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

    private func setupCellView() {
        view.addSubview(cellView)

        cellView.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            cellView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cellView.topAnchor.constraint(equalTo: view.topAnchor),
            cellView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    private func updateFlowView() {
        let context = ComponentContext
            .default
            .componentViewController(self)
            .fallbackComponentSizeCache(FallbackComponentSizeCache())

        let items = users.enumerated().map { index, user in
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
                divider: index < users.count - 1,
                tapAction: { [weak self] in
                    self?.onUserTap()
                }
            )
            .flowItem(identifier: user.fullName)
        }

        let flow = VerticalFlow(items: items)

        flowView.update(
            with: flow,
            context: context
        )
    }

    private func updateCellView() {
        let context = ComponentContext
            .default
            .componentViewController(self)
            .fallbackComponentSizeCache(FallbackComponentSizeCache())

        let user = users[0]

        let cell = Cell(
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
            divider: false,
            tapAction: { [weak self] in
                self?.onUserTap()
            }
        )

        cellView.update(
            with: cell,
            context: context
        )
    }

    private func onUserActionTap() {
    }

    private func onUserTap() {
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.tokens.backgroundColor = Colors.background.default

//        setupFlowView()
//        updateFlowView()

        setupCellView()
        updateCellView()
    }
}
