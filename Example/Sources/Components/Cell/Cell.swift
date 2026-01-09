import Levitan
import SwiftUI

struct Cell: Equatable, Sendable {

    let avatar: Avatar?
    let title: String
    let subtitle: String
    let action: CellAction?
    let divider: Bool

    @ViewAction
    var tapAction: (@MainActor () -> Void)?

    @ViewState
    private var isPressed = false
}

extension Cell: View {

    var body: some View {
        HStack(spacing: .zero) {
            avatar?.padding([.vertical, .leading], 16.0)

            VStack(alignment: .leading, spacing: .zero) {
                HStack(spacing: 8.0) {
                    VStack(alignment: .leading, spacing: 4.0) {
                        Text(title)
                            .typography(Typographies.label2)
                            .foregroundColor(Colors.text.primary)
                            .lineLimit(2)
                            .lineBreakMode(.byTruncatingTail)

                        Text(subtitle)
                            .typography(Typographies.label3)
                            .foregroundColor(Colors.text.secondary)
                            .lineLimit(2)
                            .lineBreakMode(.byTruncatingTail)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    action?.layoutPriority(1.0)
                }
                .padding([.vertical, .trailing], 16.0)

                if divider {
                    CellDivider()
                }
            }
            .padding(.leading, 16.0)
        }
        .background(isPressed ? Colors.background.pressed : nil)
        .contentShape(Rectangle())
        .onTap(tapAction)
        .onPress { isPressed = $0 && tapAction != nil }
    }
}

extension Cell: Component {

    func sizing(fitting size: CGSize, context: ComponentContext) -> ComponentSizing {
        ComponentSizing(width: .fill, height: .hug)
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
        divider: true,
        tapAction: { print("Tapped") }
    )
}
