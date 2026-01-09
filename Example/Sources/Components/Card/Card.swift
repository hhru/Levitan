import Levitan
import SwiftUI

struct Card<Content: View> {

    let content: Content
    let header: CardHeader?
}

extension Card: Equatable where Content: Equatable { }
extension Card: Sendable where Content: Sendable { }

extension Card: View {

    var body: some View {
        VStack(alignment: .leading, spacing: 12.0) {
            header

            content
                .padding(20.0)
                .frame(maxWidth: .infinity, alignment: .leading)
                .clipShape(.rounded(radius: 20.0))
                .stroke(Strokes.inside.color(Colors.stroke))
        }
        .frame(maxWidth: .infinity)
    }
}

extension Card: Component where Content: Equatable {

    func sizing(fitting size: CGSize, context: ComponentContext) -> ComponentSizing {
        ComponentSizing(width: .fill, height: .hug)
    }
}

extension View {

    func card(header: CardHeader? = nil) -> Card<Self> {
        Card(
            content: self,
            header: header
        )
    }
}

#Preview {
    HStack {
        Card(
            content: SwiftUI.Text("Hello"),
            header: CardHeader(
                title: "About me",
                editAction: { print("Tapped") }
            )
        )

        Spacer(minLength: 100)
    }
}
