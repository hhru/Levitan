import Combine
import Levitan
import UIKit

final class ProfileViewController: UIViewController {

    private let profileStore = ProfileStore.shared
    private var profileSubscription: AnyCancellable?

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

        profileSubscription = profileStore
            .profilePublisher
            .sink { [weak self] _ in
                self?.updateContentView()
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
        let profile = profileStore.profile

        let content = VFlow {
            headerItem(profile: profile)
            contactsItem(profile: profile)
            skillsItem(profile: profile)
            aboutMeItem(profile: profile)
        }
        .scrollAlwaysBounces()

        contentView.update(
            with: content,
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
        .flowItem(id: #function)
    }

    private func contactsItem(profile: Profile) -> any FlowItem {
        let header = CardHeader(
            title: "Contacts",
            editAction: { [weak self] in
                self?.onEditContactsTap()
            }
        )

        return VFlow {
            if profile.phoneNumber == nil, profile.emailAddress == nil {
                Text("No contacts added yet.")
                    .typography(Typographies.paragraph2)
                    .foregroundColor(Colors.text.secondary)
                    .flowItem(id: "empty")
            } else {
                if let phoneNumber = profile.phoneNumber {
                    ProfileContact(title: "Phone", value: phoneNumber)
                        .frame(width: .fill)
                        .flowItem(id: "phone")
                }

                if let emailAddress = profile.emailAddress {
                    ProfileContact(title: "Email", value: emailAddress)
                        .frame(width: .fill)
                        .flowItem(id: "email")
                }
            }
        }
        .verticalSpacing(8.0)
        .card(header: header)
        .padding(top: 24.0, leading: 16.0, trailing: 16.0)
        .flowItem(id: #function)
    }

    private func skillsItem(profile: Profile) -> any FlowItem {
        let header = CardHeader(
            title: "Skills",
            editAction: { [weak self] in
                self?.onEditSkillsTap()
            }
        )

        return VFlow {
            if profile.skills.isEmpty {
                Text("No skills added yet.")
                    .typography(Typographies.paragraph2)
                    .foregroundColor(Colors.text.secondary)
                    .flowItem(id: "empty")
            } else {
                profile.skills.map { skill in
                    Tag(label: skill)
                        .flowItem(id: skill)
                }
            }
        }
        .horizontalSpacing(8.0)
        .verticalSpacing(8.0)
        .card(header: header)
        .padding(top: 24.0, leading: 16.0, trailing: 16.0)
        .flowItem(id: #function)
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
                .flowItem(id: #function)
        }

        return Levitan.Text(profile.aboutMe)
            .typography(Typographies.paragraph2)
            .foregroundColor(Colors.text.primary)
            .card(header: header)
            .padding(top: 24.0, leading: 16.0, trailing: 16.0)
            .flowItem(id: #function)
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
                    self.profileStore.updateProfile(phoneNumber: Profile.default.phoneNumber)
                }
            } else {
                ActionSheetAction(title: "Remove phone number", style: .destructive) {
                    self.profileStore.updateProfile(phoneNumber: nil)
                }
            }

            if profileStore.profile.emailAddress == nil {
                ActionSheetAction(title: "Add email address") {
                    self.profileStore.updateProfile(emailAddress: Profile.default.emailAddress)
                }
            } else {
                ActionSheetAction(title: "Remove email address", style: .destructive) {
                    self.profileStore.updateProfile(emailAddress: nil)
                }
            }

            ActionSheetAction.cancel(title: "Cancel")
        }

        showActionSheet(actionSheet)
    }

    private func onEditSkillsTap() {
        let skills = profileStore.profile.skills.joined(separator: ", ")

        let alert = Alert.textEditor(
            title: "Skills",
            text: skills,
            placeholder: "Skills separated by commas",
            saveAction: { skills in
                let newSkills = skills
                    .components(separatedBy: ",")
                    .map { $0.trimmingCharacters(in: .whitespaces) }
                    .filter { !$0.isEmpty }

                self.profileStore.updateProfile(skills: newSkills)
            }
        )

        showAlert(alert)
    }

    private func onEditAboutMeTap(profile: Profile) {
        let aboutMe = profileStore.profile.aboutMe

        let alert = Alert.textEditor(
            title: "About me",
            text: aboutMe,
            placeholder: "About me",
            saveAction: { aboutMe in
                self.profileStore.updateProfile(aboutMe: aboutMe)
            }
        )

        showAlert(alert)
    }
}
