import SwiftUI

struct Avatar: Equatable, Sendable {

    let url: URL?
    let placeholder: Image
    let size: AvatarSize
}

extension Avatar: View {

    var body: some View {
        AsyncImage(url: url) { image in
            image.resizable()
        } placeholder: {
            placeholder.resizable()
        }
        .frame(width: size.value, height: size.value)
        .clipShape(.capsule)
    }
}

#Preview {
    Avatar(
        url: nil,
        placeholder: Image(.avatarPlaceholder),
        size: .small
    )
}
