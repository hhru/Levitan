import Levitan
import SwiftUI

struct Tag: Component, Sendable {

    let label: String
}

extension Tag: View {

    var body: some View {
        Text(label)
            .typography(Typographies.label3)
            .foregroundColor(Colors.tag.label)
            .padding(.vertical, 4.0)
            .padding(.horizontal, 8.0)
            .background(Colors.tag.background)
            .clipShape(.rounded(radius: 8.0))
    }
}

#Preview {
    Tag(label: "Xcode")
}
