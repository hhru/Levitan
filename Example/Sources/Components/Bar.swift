import SwiftUI
import Levitan

struct Bar: Component {

    let title: String
    let color: Color

    var body: some SwiftUI.View {
        Text(title)
            .font(.title)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(color)
    }

    func sizing(fitting size: CGSize, context: ComponentContext) -> ComponentSizing {
        ComponentSizing(
            width: .fill,
            height: .hug
        )
    }
}
