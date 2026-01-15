import Levitan
import UIKit

final class TestElementView: UIView {

    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        tokens.stroke = Strokes.outside.color(Colors.stroke)

        setupLabel()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLabel() {
        addSubview(label)

        label.font = .preferredFont(forTextStyle: .title2)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 8.0),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.0),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0)
        ]

        NSLayoutConstraint.activate(constraints)
    }
}

extension TestElementView: FallbackComponentView {

    static func sizing(
        for content: TestElement,
        fitting size: CGSize,
        context: ComponentContext
    ) -> ComponentSizing {
        ComponentSizing(
            width: .fill,
            height: .hug
        )
    }

    func update(with content: TestElement, context: ComponentContext) {
        label.text = content.description.map { description in
            "\(content.title)\n\(description)"
        } ?? content.title

        label.tokens.textColor = content.textColor
        tokens.backgroundColor = content.backgroundColor
    }
}
