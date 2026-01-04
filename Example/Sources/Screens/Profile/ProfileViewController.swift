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
            headerItem(profile: profile)
            contactsItem(profile: profile)
            skillsItem(profile: profile)
            aboutMeItem(profile: profile)
        }

        flowView.update(
            with: flow,
            context: context
        )
    }
}

extension ProfileViewController {

    private func headerItem(profile: Profile) -> any FlowItem {
        ProfileHeader(
            photoURL: profile.photoURL,
            name: profile.name,
            position: profile.position
        )
        .frame(width: .fill)
        .padding(top: 16.0, leading: 16.0, trailing: 16.0)
        .flowItem(identifier: #function)
    }

    private func contactsItem(profile: Profile) -> any FlowItem {
        let header = CardHeader(
            title: "Contacts",
            editAction: { [weak self] in
                self?.onEditContactsTap()
            }
        )

        return VerticalFlow {
            if profile.phoneNumber == nil, profile.emailAddress == nil {
                Text("No contacts added yet.")
                    .typography(Typographies.paragraph2)
                    .foregroundColor(Colors.text.secondary)
                    .flowItem(identifier: "empty")
            } else {
                if let phoneNumber = profile.phoneNumber {
                    ProfileContact(title: "Phone", value: phoneNumber)
                        .frame(width: .fill)
                        .flowItem(identifier: "phone")
                }

                if let emailAddress = profile.emailAddress {
                    ProfileContact(title: "Email", value: emailAddress)
                        .frame(width: .fill)
                        .flowItem(identifier: "email")
                }
            }
        }
        .verticalSpacing(8.0)
        .card(header: header)
        .padding(top: 24.0, leading: 16.0, trailing: 16.0)
        .flowItem(identifier: #function)
    }

    private func skillsItem(profile: Profile) -> any FlowItem {
        let header = CardHeader(
            title: "Skills",
            editAction: { [weak self] in
                self?.onEditSkillsTap()
            }
        )

        return VerticalFlow {
            if profile.skills.isEmpty {
                Text("No skills added yet.")
                    .typography(Typographies.paragraph2)
                    .foregroundColor(Colors.text.secondary)
                    .flowItem(identifier: "empty")
            } else {
                profile.skills.map { skill in
                    Tag(label: skill)
                        .flowItem(identifier: skill)
                }
            }
        }
        .horizontalSpacing(8.0)
        .verticalSpacing(8.0)
        .card(header: header)
        .padding(top: 24.0, leading: 16.0, trailing: 16.0)
        .flowItem(identifier: #function)
    }

    private func aboutMeItem(profile: Profile) -> any FlowItem {
        let header = CardHeader(
            title: "About me",
            editAction: { [weak self] in
                self?.onEditAboutMeTap(profile: profile)
            }
        )

        if profile.aboutMe.isEmpty {
            return Text("No bio added yet.")
                .typography(Typographies.paragraph2)
                .foregroundColor(Colors.text.secondary)
                .card(header: header)
                .padding(top: 24.0, leading: 16.0, trailing: 16.0)
                .flowItem(identifier: #function)
        }

        return Levitan.Text(profile.aboutMe)
            .typography(Typographies.paragraph2)
            .foregroundColor(Colors.text.primary)
            .card(header: header)
            .padding(top: 24.0, leading: 16.0, trailing: 16.0)
            .flowItem(identifier: #function)
    }
}

extension ProfileViewController {

    private func onEditContactsTap() {
        var actions: [ActionSheetAction] = []

        if profileStore.profile.phoneNumber == nil {
            let action = ActionSheetAction(title: "Add phone number") {
                self.profileStore.updateProfilePhoneNumber(with: Profile.default.phoneNumber)
            }

            actions.append(action)
        } else {
            let action = ActionSheetAction(title: "Remove phone number", style: .destructive) {
                self.profileStore.updateProfilePhoneNumber(with: nil)
            }

            actions.append(action)
        }

        if profileStore.profile.emailAddress == nil {
            let action = ActionSheetAction(title: "Add email address") {
                self.profileStore.updateProfileEmailAddress(with: Profile.default.emailAddress)
            }

            actions.append(action)
        } else {
            let action = ActionSheetAction(title: "Remove email address", style: .destructive) {
                self.profileStore.updateProfileEmailAddress(with: nil)
            }

            actions.append(action)
        }

        actions.append(.cancel(title: "Cancel"))

        let actionSheet = ActionSheet(
            title: "Contacts",
            tintColor: UIColor(named: "AccentColor"),
            actions: actions
        )

        showActionSheet(actionSheet)
    }

    private func onEditSkillsTap() {
        let skills = profileStore.profile.skills.joined(separator: ", ")

        let textField = AlertTextField(
            text: skills,
            placeholder: "Skills separated by commas"
        )

        let saveAction = AlertAction(title: "Save") { texts in
            let newSkills = texts
                .first?
                .components(separatedBy: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) } ?? []

            self.profileStore.updateProfileSkills(with: newSkills)
        }

        let resetAction = AlertAction(title: "Reset", style: .destructive) {
            self.profileStore.updateProfileSkills(with: [])
        }

        let cancelAction = AlertAction.cancel(title: "Cancel")

        let alert = Alert(
            title: "Skills",
            tintColor: UIColor(named: "AccentColor"),
            textFields: [textField],
            actions: [saveAction, resetAction, cancelAction]
        )

        showAlert(alert)
    }

    private func onEditAboutMeTap(profile: Profile) {
        let aboutMe = profileStore.profile.aboutMe

        let textField = AlertTextField(
            text: aboutMe,
            placeholder: "About me"
        )

        let saveAction = AlertAction(title: "Save") { texts in
            self.profileStore.updateProfileAboutMe(with: texts.first ?? "")
        }

        let resetAction = AlertAction(title: "Reset", style: .destructive) {
            self.profileStore.updateProfileAboutMe(with: "")
        }

        let cancelAction = AlertAction.cancel(title: "Cancel")

        let alert = Alert(
            title: "About Me",
            tintColor: UIColor(named: "AccentColor"),
            textFields: [textField],
            actions: [saveAction, resetAction, cancelAction]
        )

        showAlert(alert)
    }
}
