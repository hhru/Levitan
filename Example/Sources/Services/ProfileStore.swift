import Foundation
import Combine

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

    func updateProfileSkills(with skills: [String]) {
        profileSubject.send(profile.changing { $0.skills = skills })
    }

    func updateProfileAboutMe(with aboutMe: String) {
        profileSubject.send(profile.changing { $0.aboutMe = aboutMe })
    }
}
