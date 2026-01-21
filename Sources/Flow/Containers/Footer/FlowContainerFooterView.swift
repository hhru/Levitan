#if canImport(UIKit)
import UIKit

public final class FlowContainerFooterView<Content: Component>: AnyFlowSupplementaryView {

    private let contentView: Content.UIView

    private var appearAction: (@MainActor () -> Void)?
    private var disappearAction: (@MainActor () -> Void)?

    private let appearance = ComponentAppearance()

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

extension FlowContainerFooterView {

    private func setupContentView() {
        addSubview(contentView)

        contentView.translatesAutoresizingMaskIntoConstraints = false

        contentView
            .topAnchor
            .constraint(equalTo: topAnchor)
            .activate()

        contentView
            .leadingAnchor
            .constraint(equalTo: leadingAnchor)
            .activate()

        contentView
            .trailingAnchor
            .constraint(equalTo: trailingAnchor)
            .priority(.almostRequired)
            .activate()

        contentView
            .bottomAnchor
            .constraint(equalTo: bottomAnchor)
            .priority(.almostRequired)
            .activate()
    }
}

extension FlowContainerFooterView: ComponentAppearanceView { }

extension FlowContainerFooterView: FlowFooterView {

    public static func sizing(
        for footer: FlowContainerFooter<Content>,
        fitting size: CGSize,
        context: ComponentContext
    ) -> ComponentSizing {
        Logger.debug(
            ["\(Self.self).\(#function)"],
            ["id:", context.componentID ?? "nil"],
            ["size:", size],
            subsystem: "Flow",
            category: "FlowContainerFooterView"
        )

        return footer.content.sizing(
            fitting: size,
            context: context
        )
    }

    public func update(
        with footer: FlowContainerFooter<Content>,
        context: ComponentContext
    ) {
        Logger.debug(
            ["\(Self.self).\(#function)"],
            ["id:", context.componentID ?? "nil"],
            subsystem: "Flow",
            category: "FlowContainerFooterView"
        )

        let context = context.componentAppearance(
            appearance,
            of: self
        )

        accessibilityIdentifier = footer.accessibilityIdentifier

        appearAction = footer.appearAction
        disappearAction = footer.disappearAction

        contentView.update(
            with: footer.content,
            context: context
        )
    }
}
#endif
