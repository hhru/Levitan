import Combine
import Levitan
import SwiftUI
import UIKit

final class ProfileViewController: UIViewController {

    private let profileStore = ProfileStore.shared
    private var profileSubscription: AnyCancellable?

    private let flowView = VerticalFlow.UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.tokens.backgroundColor = Colors.background.default

        setupFlowView()

        profileSubscription = profileStore
            .profilePublisher
            .sink { [weak self] profile in
                self?.updateFlowView(profile: profile)
            }
    }
}

extension ProfileViewController {

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

    private func updateFlowView(profile: Profile) {
        let context = ComponentContext
            .default
            .componentViewController(self)
            .fallbackComponentSizeCache(FallbackComponentSizeCache())

        let flow = VerticalFlow {
            skillsItem(profile: profile)
            aboutMeItem(profile: profile)
        }

        flowView.update(
            with: flow,
            context: context
        )
    }

    private func onEditSkillsTap() {

    }

    private func onEditAboutMeTap() {

    }
}

extension ProfileViewController {

    func skillsItem(profile: Profile) -> any FlowItem {
        let header = CardHeader(
            title: "Skills",
            editAction: { [weak self] in
                self?.onEditSkillsTap()
            }
        )

        return VerticalFlow {
            profile.skills.map { skill in
                Tag(label: skill)
                    .flowItem(identifier: skill)
            }
        }
        .card(header: header)
        .padding(all: 16.0)
        .flowItem(identifier: #function)
    }

    func aboutMeItem(profile: Profile) -> any FlowItem {
        let header = CardHeader(
            title: "About me",
            editAction: { [weak self] in
                self?.onEditAboutMeTap()
            }
        )

        return Levitan.Text(profile.aboutMe)
            .typography(Typographies.paragraph2)
            .foregroundColor(Colors.text.primary)
            .card(header: header)
            .padding(all: 16.0)
            .flowItem(identifier: #function)
    }
}
