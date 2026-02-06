import Foundation
import Levitan

struct Profile: Changeable, Hashable, Sendable {

    var photoURL: URL?
    var name: String
    var position: String

    var phoneNumber: String?
    var emailAddress: String?

    var skills: [String]
    var aboutMe: String
}

extension Profile {

    static let `default` = Self(
        photoURL: URL(string: "https://avatars.githubusercontent.com/u/85987542"),
        name: "Steve Jobs",
        position: "Co-founder, Former CEO of Apple Inc.",
        phoneNumber: "+1 408-555-1234",
        emailAddress: "steve.jobs@apple.com",
        skills: ["Product Design", "Marketing", "Leadership", "Innovation"],
        aboutMe: """
            - I co-founded Apple in my parents' garage.
            - I dropped out of college but loved calligraphy.
            - I was fired from Apple, then returned to lead it.
            - I believe in simplicity and great design.
            - I’m passionate about changing the world with technology.
            """
    )
}
