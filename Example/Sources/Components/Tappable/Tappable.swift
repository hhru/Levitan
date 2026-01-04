import Levitan
import SwiftUI

struct Tappable<Content: View> {

    let content: Content

    @ViewAction
    var tapAction: (@MainActor () -> Void)?

    @ViewAction
    var pressAction: (@MainActor (_ isPressed: Bool) -> Void)?
}

extension Tappable: Equatable where Content: Equatable { }
extension Tappable: Sendable where Content: Sendable { }

extension Tappable: View {

    public var body: some View {
        let buttonStyle = TappableButtonStyle { isPressed in
            pressAction?(isPressed)
        }

        Button(
            action: { tapAction?() },
            label: { content }
        )
        .buttonStyle(buttonStyle)
    }
}

extension Tappable: Changeable {

    func onTap(_ tapAction: (@MainActor () -> Void)?) -> Self {
        guard let tapAction else {
            return self
        }

        guard let previousAction = self.tapAction else {
            return changing { $0.tapAction = tapAction }
        }

        let newAction = { @MainActor in
            previousAction()
            tapAction()
        }

        return changing { $0.tapAction = newAction }
    }

    func onPress(_ pressAction: (@MainActor (_ isPressed: Bool) -> Void)?) -> Self {
        guard let pressAction else {
            return self
        }

        guard let previousAction = self.pressAction else {
            return changing { $0.pressAction = pressAction }
        }

        let newAction = { @MainActor isPressed in
            previousAction(isPressed)
            pressAction(isPressed)
        }

        return changing { $0.pressAction = newAction }
    }
}

extension View {

    nonisolated func onTap(_ tapAction: (@MainActor () -> Void)?) -> Tappable<Self> {
        Tappable(content: self, tapAction: tapAction)
    }
}
