import UIKit

public final class ListContainerHeaderView<Content: Component>: AnyListSupplementaryView {

    private let contentView: Content.UIView

    private var appearAction: (() -> Void)?
    private var disappearAction: (() -> Void)?

    public override var canBecomeFirstResponder: Bool {
        contentView.canBecomeFirstResponder
    }

    public override var canResignFirstResponder: Bool {
        contentView.canResignFirstResponder
    }

    public override var isFirstResponder: Bool {
        contentView.isFirstResponder
    }

    public override init(frame: CGRect = .zero) {
        contentView = Content.UIView(frame: frame)

        super.init(frame: frame)

        backgroundColor = .clear
        clipsToBounds = false

        setupContentView()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupContentView() {
        addSubview(contentView)

        contentView.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    @discardableResult
    public override func becomeFirstResponder() -> Bool {
        contentView.becomeFirstResponder()
    }

    @discardableResult
    public override func resignFirstResponder() -> Bool {
        contentView.resignFirstResponder()
    }

    public override func onAppear() {
        appearAction?()
    }

    public override func onDisappear() {
        disappearAction?()
    }
}

extension ListContainerHeaderView: ListHeaderView {

    public static func sizing(
        for header: ListContainerHeader<Content>,
        fitting size: CGSize,
        context: ComponentContext
    ) -> ComponentSizing {
        header.content.sizing(
            fitting: size,
            context: context
        )
    }

    public func update(
        with header: ListContainerHeader<Content>,
        context: ComponentContext
    ) {
        accessibilityIdentifier = header.accessibilityIdentifier

        appearAction = header.appearAction
        disappearAction = header.disappearAction

        contentView.update(
            with: header.content,
            context: context
        )
    }
}
