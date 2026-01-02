import Levitan
import SwiftUI

struct Cell: Equatable, Sendable {

    let avatar: Avatar?
    let title: String
    let subtitle: String
    let action: CellAction?
    let divider: CellDivider?

    @ViewAction
    var tapAction: (@MainActor () -> Void)?

    @ViewState
    private var isPressed = false
}

extension Cell: Component {

    var body: some View {
        HStack(spacing: .zero) {
            avatar?.padding([.vertical, .leading], 16.0)

            VStack(alignment: .leading, spacing: .zero) {
                HStack(spacing: 8.0) {
                    VStack(alignment: .leading, spacing: 4.0) {
                        Text(title)
                            .typography(Typographies.label2)
                            .foregroundColor(Colors.text.primary)

                        Text(subtitle)
                            .typography(Typographies.label3)
                            .foregroundColor(Colors.text.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    action?.layoutPriority(1)
                }
                .padding([.vertical, .trailing], 16.0)

                divider
            }
            .padding(.leading, 16)
        }
        .background(isPressed ? Colors.background.pressed : nil)
        .contentShape(Rectangle())
        .onTap(tapAction)
        .onPress { isPressed = $0 && tapAction != nil }
    }

    func sizing(fitting size: CGSize, context: ComponentContext) -> ComponentSizing {
        ComponentSizing(width: .fill, height: .hug(forced: true))
    }
}

#Preview {
    Cell(
        avatar: Avatar(
            url: nil,
            placeholder: Image(.avatarPlaceholder),
            size: .small
        ),
        title: "Title",
        subtitle: "Subtitle",
        action: CellAction(
            title: "Edit",
            action: { print("Action tapped") }
        ),
        divider: CellDivider(),
        tapAction: { print("Tapped") }
    )
}
