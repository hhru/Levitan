import UIKit

public final class ListContainerCell<Content: Component>: AnyListCell {

    private let itemContentView: Content.UIView

    private var selectAction: ((_ deselection: Deselection) -> Void)?
    private var deselectAction: (() -> Void)?

    private var appearAction: (() -> Void)?
    private var disappearAction: (() -> Void)?

    public override var canBecomeFirstResponder: Bool {
        itemContentView.canBecomeFirstResponder
    }

    public override var canResignFirstResponder: Bool {
        itemContentView.canResignFirstResponder
    }

    public override var isFirstResponder: Bool {
        itemContentView.isFirstResponder
    }

    public override init(frame: CGRect = .zero) {
        itemContentView = Content.UIView(frame: frame)

        super.init(frame: frame)

        selectedBackgroundView = nil
        backgroundColor = .clear
        clipsToBounds = false

        setupItemContentView()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    private func setupItemContentView() {
        contentView.addSubview(itemContentView)

        itemContentView.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            itemContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            itemContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            itemContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            itemContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    @discardableResult
    public override func becomeFirstResponder() -> Bool {
        itemContentView.becomeFirstResponder()
    }

    @discardableResult
    public override func resignFirstResponder() -> Bool {
        itemContentView.resignFirstResponder()
    }

    public override func onSelect(deselection: Deselection) {
        selectAction?(deselection)
    }

    public override func onDeselect() {
        deselectAction?()
    }

    public override func onAppear() {
        appearAction?()
    }

    public override func onDisappear() {
        disappearAction?()
    }
}

extension ListContainerCell: ListCell {

    public static func sizing(
        for item: ListContainerItem<Content>,
        fitting size: CGSize,
        context: ComponentContext
    ) -> ComponentSizing {
        item.content.sizing(
            fitting: size,
            context: context
        )
    }

    public func update(
        with item:  ListContainerItem<Content>,
        context: ComponentContext
    ) {
        selectAction = item.selectAction
        deselectAction = item.deselectAction

        appearAction = item.appearAction
        disappearAction = item.disappearAction

        accessibilityIdentifier = item.accessibilityIdentifier

        itemContentView.update(
            with: item.content,
            context: context
        )
    }
}
