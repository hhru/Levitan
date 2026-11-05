#if canImport(UIKit)
import Levitan
import UIKit

final class TestingBoxView: UIView {

    private let boxView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        boxView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(boxView)

        let boxConstraints = [
            boxView.topAnchor.constraint(equalTo: topAnchor),
            boxView.leadingAnchor.constraint(equalTo: leadingAnchor),
            boxView.bottomAnchor.constraint(equalTo: bottomAnchor),
            boxView.trailingAnchor.constraint(equalTo: trailingAnchor),
            boxView.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            boxView.heightAnchor.constraint(greaterThanOrEqualToConstant: 30)
        ]

        NSLayoutConstraint.activate(boxConstraints)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TestingBoxView: FallbackComponentView {

    static func sizing(
        for content: TestingBox,
        fitting size: CGSize,
        context: ComponentContext
    ) -> ComponentSizing {
        content.sizing
    }

    func update(with content: TestingBox, context: ComponentContext) { }
}
#endif
