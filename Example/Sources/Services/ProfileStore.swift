import Combine
import Foundation

@MainActor
final class ProfileStore {

    private let profileSubject = CurrentValueSubject<Profile, Never>(.default)

    private init() { }
}

extension ProfileStore {

    static let shared = ProfileStore()

    var profile: Profile {
        profileSubject.value
    }

    var profilePublisher: AnyPublisher<Profile, Never> {
        profileSubject.eraseToAnyPublisher()
    }

    func updateProfile(with profile: Profile) {
        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)

            profileSubject.send(profile)
        }
    }

    func updateProfile(phoneNumber: String?) {
        updateProfile(with: profile.changing { $0.phoneNumber = phoneNumber })
    }

    func updateProfile(emailAddress: String?) {
        updateProfile(with: profile.changing { $0.emailAddress = emailAddress })
    }

    func updateProfile(skills: [String]) {
        updateProfile(with: profile.changing { $0.skills = skills })
    }

    func updateProfile(aboutMe: String) {
        updateProfile(with: profile.changing { $0.aboutMe = aboutMe })
    }
}
