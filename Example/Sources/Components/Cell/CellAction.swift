import Levitan
import SwiftUI

struct CellAction: Equatable, Sendable {

    let title: String

    @ViewAction
    var action: @MainActor () -> Void

    @ViewState
    private var isPressed = false
}

extension CellAction: View {

    var body: some View {
        Text(title)
            .typography(Typographies.label2)
            .foregroundColor(Colors.accent)
            .onTap(action)
            .onPress { isPressed = $0 }
            .pressedEffect(isPressed, anchor: .trailing)
    }
}

#Preview {
    CellAction(title: "Action") {
        print("Tapped")
    }
}
