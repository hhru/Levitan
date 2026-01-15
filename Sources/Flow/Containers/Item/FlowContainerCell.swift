#if canImport(UIKit)
import UIKit

public final class FlowContainerCell<Content: Component>: AnyFlowCell {

    private let itemContentView: Content.UIView

    private var selectAction: (@MainActor (_ deselection: Deselection) -> Void)?
    private var deselectAction: (@MainActor () -> Void)?

    private var appearAction: (@MainActor () -> Void)?
    private var disappearAction: (@MainActor () -> Void)?

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

extension FlowContainerCell {

    private func setupItemContentView() {
        contentView.addSubview(itemContentView)

        itemContentView.translatesAutoresizingMaskIntoConstraints = false

        itemContentView
            .topAnchor
            .constraint(equalTo: contentView.topAnchor)
            .activate()

        itemContentView
            .leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor)
            .activate()

        itemContentView
            .trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor)
            .priority(.almostRequired)
            .activate()

        itemContentView
            .bottomAnchor
            .constraint(equalTo: contentView.bottomAnchor)
            .priority(.almostRequired)
            .activate()
    }
}

extension FlowContainerCell: FlowCell {

    public static func sizing(
        for item: FlowContainerItem<Content>,
        fitting size: CGSize,
        context: ComponentContext
    ) -> ComponentSizing {
        Logger.debug(
            ["\(Self.self).\(#function)"],
            ["id:", context.componentID ?? "nil"],
            ["size:", size],
            subsystem: "Flow",
            category: "FlowContainerCell"
        )

        return item.content.sizing(
            fitting: size,
            context: context
        )
    }

    public func update(
        with item:  FlowContainerItem<Content>,
        context: ComponentContext
    ) {
        Logger.debug(
            ["\(Self.self).\(#function)"],
            ["id:", context.componentID ?? "nil"],
            subsystem: "Flow",
            category: "FlowContainerCell"
        )

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
#endif
