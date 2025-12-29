import SwiftUI

struct UserView: View {

    let user: User

    @State
    private var isFavorite = false

    private var mainInfo: some View {
        VStack(spacing: .zero) {
            Avatar(
                url: user.photoURL,
                placeholder: Image(.avatarPlaceholder),
                size: .large
            )

            HStack(alignment: .center, spacing: 4) {
                Text(user.fullName)
                    .font(.largeTitle)

                FavoriteToggle(isSelected: $isFavorite)
                    .disabled(user.position == "Android Developer")
            }
            .padding(.top, 24)

            Text(user.position)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.top, 4)
        }
    }

    private var contacts: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Contacts")
                .font(.title3)
                .bold()

            VStack(alignment: .leading, spacing: .zero) {
                Text("Phone")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(user.phoneNumber)
                    .font(.body)
                    .padding(.top, 4)

                Text("Email")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.top, 16)

                Text(user.emailAddress)
                    .font(.body)
                    .padding(.top, 4)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .clipShape(.rect(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(.divider))
            )
        }
    }

    private var skills: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Skills")
                .font(.title3)
                .bold()

            ScrollView(.horizontal) {
                Tags(items: user.skills)
                    .padding(16)
            }
            .scrollIndicators(.never)
            .clipShape(.rect(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(.divider))
            )
        }
    }

    private var aboutMe: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("About me")
                .font(.title3)
                .bold()

            Text(user.aboutMe)
                .font(.body)
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .clipShape(.rect(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(.divider))
                )
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                mainInfo
                contacts
                skills
                aboutMe
            }
            .padding(16)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("User").font(.headline)
            }
        }
    }
}

#Preview {
    NavigationStack {
        UserView(user: User.all[0])
    }
}
