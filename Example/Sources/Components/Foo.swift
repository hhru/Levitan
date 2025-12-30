import UIKit
import Levitan

// swiftlint:disable file_types_order

struct Foo: FallbackComponent {

    typealias UIView = FooView

    let title: String
    let color: UIColor
}

final class FooView: UIView {

    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        tokens.stroke = .inside(width: 1.0, color: 0x000000FF)

        setupLabel()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLabel() {
        addSubview(label)

        label.numberOfLines = 0

        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
}

extension FooView: FallbackComponentView {

    static func sizing(
        for content: Foo,
        fitting size: CGSize,
        context: ComponentContext
    ) -> ComponentSizing {
        ComponentSizing(
            width: .fill,
            height: .hug(bounded: true)
        )
    }

    func update(with content: Foo, context: ComponentContext) {
        label.attributedText = NSAttributedString(
            string: content.title,
            attributes: [.font: UIFont.preferredFont(forTextStyle: .title1)]
        )

        backgroundColor = content.color
    }
}
