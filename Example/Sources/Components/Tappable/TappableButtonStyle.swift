import SwiftUI

struct TappableButtonStyle: ButtonStyle {

    var pressAction: @MainActor (_ isPressed: Bool) -> Void

    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .onChange(of: configuration.isPressed, perform: pressAction)
    }
}
