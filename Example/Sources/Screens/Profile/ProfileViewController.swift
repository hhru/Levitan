import Combine
import Levitan
import UIKit

final class ProfileViewController: UIViewController {

    private let profileStore = ProfileStore.shared
    private var profileSubscription: AnyCancellable?

    private let flowView = VerticalFlow.UIView()
    private var flowContext = ComponentContext.default

    override func viewDidLoad() {
        super.viewDidLoad()

        view.tokens.backgroundColor = Colors.background.default

        setupNavigationBar()
        setupFlowView()
        setupFlowContext()

        profileSubscription = profileStore
            .profilePublisher
            .sink { [weak self] _ in
                self?.updateFlowView()
            }
    }
}

extension ProfileViewController {

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Reset",
            style: .plain,
            target: self,
            action: #selector(onResetProfileTap)
        )
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
        let profile = profileStore.profile

        let flow = VerticalFlow {
            headerItem(profile: profile)
            contactsItem(profile: profile)
            skillsItem(profile: profile)
            aboutMeItem(profile: profile)
        }

        flowView.update(with: flow, context: flowContext)
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

    @objc private func onResetProfileTap() {
        profileStore.updateProfile(with: .default)
    }

    private func onEditContactsTap() {
        let actionSheet = ActionSheet(title: "Contacts") {
            if profileStore.profile.phoneNumber == nil {
                ActionSheetAction(title: "Add phone number") {
                    self.profileStore.updateProfilePhoneNumber(with: Profile.default.phoneNumber)
                }
            } else {
                ActionSheetAction(title: "Remove phone number", style: .destructive) {
                    self.profileStore.updateProfilePhoneNumber(with: nil)
                }
            }

            if profileStore.profile.emailAddress == nil {
                ActionSheetAction(title: "Add email address") {
                    self.profileStore.updateProfileEmailAddress(with: Profile.default.emailAddress)
                }
            } else {
                ActionSheetAction(title: "Remove email address", style: .destructive) {
                    self.profileStore.updateProfileEmailAddress(with: nil)
                }
            }

            ActionSheetAction.cancel(title: "Cancel")
        }

        showActionSheet(actionSheet)
    }

    private func onEditSkillsTap() {
        let skills = profileStore.profile.skills.joined(separator: ", ")

        let textField = AlertTextField(
            text: skills,
            placeholder: "Skills separated by commas"
        )

        let alert = Alert(title: "Skills", textFields: [textField]) {
            AlertAction(title: "Save") { texts in
                let newSkills = texts
                    .first?
                    .components(separatedBy: ",")
                    .map { $0.trimmingCharacters(in: .whitespaces) } ?? []

                self.profileStore.updateProfileSkills(with: newSkills)
            }

            AlertAction(title: "Reset", style: .destructive) {
                self.profileStore.updateProfileSkills(with: [])
            }

            AlertAction.cancel(title: "Cancel")
        }

        showAlert(alert)
    }

    private func onEditAboutMeTap(profile: Profile) {
        let aboutMe = profileStore.profile.aboutMe

        let textField = AlertTextField(
            text: aboutMe,
            placeholder: "About me"
        )

        let alert = Alert(title: "About me", textFields: [textField]) {
            AlertAction(title: "Save") { texts in
                self.profileStore.updateProfileAboutMe(with: texts.first ?? "")
            }

            AlertAction(title: "Reset", style: .destructive) {
                self.profileStore.updateProfileAboutMe(with: "")
            }

            AlertAction.cancel(title: "Cancel")
        }

        showAlert(alert)
    }
}
