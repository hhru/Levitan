import Levitan
import SwiftUI

struct ProfileContact: Equatable, Sendable {

    let title: String
    let value: String
}

extension ProfileContact: View {

    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text(title)
                .typography(Typographies.label3)
                .foregroundColor(Colors.text.secondary)

            Text(value)
                .typography(Typographies.label2)
                .foregroundColor(Colors.text.primary)
                .padding(top: 4.0)
        }
        .frame(width: .fill, alignment: .leading)
    }
}

#Preview {
    ProfileContact(
        title: "Email",
        value: "steve.jobs@apple.com"
    )
}
