#if canImport(UIKit)
import SwiftUI
import UIKit
import XCTest
@testable import Levitan

private struct NestedText: Component {

    let text: String

    var body: some View {
        Text(text)
    }
}

private struct NestingCard: FallbackComponent {

    typealias UIView = NestingCardView

    let text: String
}

@MainActor
private enum NestingCardLeaks {

    static var texts: [String] = []
}

/// UIKit-компонент со SwiftUI-содержимым, как карточка дизайн-системы.
private final class NestingCardView: UIView {

    private let contentView = ComponentHostingView<NestedText>()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        addSubview(contentView)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private struct NestingRoot: View {

    let revision: Int

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(0..<3) { index in
                    NestingCard(text: "\(index)-\(revision)")
                }
            }
        }
    }
}

@MainActor
final class ComponentHostingNestingTests: XCTestCase {

    func testNestedHostingControllerDoesNotLeakIntoParentComponentContext() {
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 402, height: 874))
        let hostingController = UIHostingController(rootView: NestingRoot(revision: 0))

        NestingCardLeaks.texts = []

        window.rootViewController = hostingController
        window.makeKeyAndVisible()

        // Утечка проявляется только на повторных обновлениях уже встроенных компонентов
        for revision in 0..<3 {
            hostingController.rootView = NestingRoot(revision: revision)
            hostingController.view.setNeedsLayout()
            hostingController.view.layoutIfNeeded()

            RunLoop.main.run(until: Date().addingTimeInterval(0.3))
        }

        XCTAssertEqual(NestingCardLeaks.texts, [])
        XCTAssertFalse(hostingController.children.isEmpty)

        window.isHidden = true
    }
}

extension NestingCardView: FallbackComponentView {

    static func sizing(
        for content: NestingCard,
        fitting size: CGSize,
        context: ComponentContext
    ) -> ComponentSizing {
        ComponentSizing(width: .fill, height: .fixed(44.0))
    }

    func update(with content: NestingCard, context: ComponentContext) {
        // Контекст карточки не должен содержать ее собственный UIHostingController:
        // иначе ComponentHostingView добавит его дочерним самому себе, и UIKit упадет с переполнением стека.
        // Обновление пропускается, чтобы утечка завершила тест проверкой, а не падением.
        if context.componentViewController is ComponentHostingController<ComponentHostingRoot<NestedText>> {
            return NestingCardLeaks.texts.append(content.text)
        }

        contentView.update(
            with: NestedText(text: content.text),
            context: context
        )
    }
}
#endif
