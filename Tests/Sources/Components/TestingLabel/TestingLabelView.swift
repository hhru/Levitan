#if canImport(UIKit)
import Levitan
import UIKit

final class TestingLabelView: UIView {

    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false

        addSubview(label)

        let labelConstraints = [
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]

        NSLayoutConstraint.activate(labelConstraints)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TestingLabelView: FallbackComponentView {

    static func sizing(
        for content: TestingLabel,
        fitting size: CGSize,
        context: ComponentContext
    ) -> ComponentSizing {
        content.sizing
    }

    func update(with content: TestingLabel, context: ComponentContext) {
        label.text = content.text
    }
}
#endif
