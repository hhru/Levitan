import Levitan
import SwiftUI

struct ProfileHeader: Equatable, Sendable {

    let photoURL: URL?
    let name: String
    let position: String
}

extension ProfileHeader: View {

    var body: some View {
        VStack(spacing: .zero) {
            Avatar(
                url: photoURL,
                placeholder: Image(.avatarPlaceholder),
                size: .large
            )

            Text(name)
                .typography(Typographies.title3)
                .foregroundColor(Colors.text.primary)
                .padding(top: 16.0)

            Text(position)
                .typography(Typographies.paragraph2)
                .foregroundColor(Colors.text.secondary)
                .padding(top: 4.0)
        }
    }
}

#Preview {
    ProfileHeader(
        photoURL: URL(string: "https://avatars.githubusercontent.com/u/85987542"),
        name: "Steve Jobs",
        position: "Co-founder, Former CEO of Apple Inc."
    )
}
