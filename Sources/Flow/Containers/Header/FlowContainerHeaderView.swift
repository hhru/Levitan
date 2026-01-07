#if canImport(UIKit)
import UIKit

public final class FlowContainerHeaderView<Content: Component>: AnyFlowSupplementaryView {

    private let contentView: Content.UIView

    private var appearAction: (@MainActor () -> Void)?
    private var disappearAction: (@MainActor () -> Void)?

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

        contentView
            .topAnchor
            .constraint(equalTo: contentView.topAnchor)
            .activate()

        contentView
            .leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor)
            .activate()

        contentView
            .trailingAnchor
            .constraint(equalTo: contentView.trailingAnchor)
            .priority(.almostRequired)
            .activate()

        contentView
            .bottomAnchor
            .constraint(equalTo: contentView.bottomAnchor)
            .priority(.almostRequired)
            .activate()
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

extension FlowContainerHeaderView: FlowHeaderView {

    public static func sizing(
        for header: FlowContainerHeader<Content>,
        fitting size: CGSize,
        context: ComponentContext
    ) -> ComponentSizing {
        header.content.sizing(
            fitting: size,
            context: context
        )
    }

    public func update(
        with header: FlowContainerHeader<Content>,
        context: ComponentContext
    ) {
        print("\(Self.self)<\(Unmanaged.passUnretained(self).toOpaque())>.\(#function)")

        accessibilityIdentifier = header.accessibilityIdentifier

        appearAction = header.appearAction
        disappearAction = header.disappearAction

        contentView.update(
            with: header.content,
            context: context
        )
    }
}
#endif
