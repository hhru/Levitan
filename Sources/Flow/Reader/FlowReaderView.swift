#if canImport(UIKit)
import UIKit

public final class FlowReaderView<Layout: FlowLayout>: UIView {

    private let flowView: FlowView<Layout>

    public override init(frame: CGRect = .zero) {
        flowView = FlowView(frame: frame)

        super.init(frame: frame)

        setupFlowView()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupFlowView() {
        addSubview(flowView)

        flowView.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            flowView.leadingAnchor.constraint(equalTo: leadingAnchor),
            flowView.topAnchor.constraint(equalTo: topAnchor),
            flowView.trailingAnchor.constraint(equalTo: trailingAnchor),
            flowView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }
}

extension FlowReaderView: FallbackComponentView {

    public static func sizing(
        for content: Content,
        fitting size: CGSize,
        context: ComponentContext
    ) -> ComponentSizing {
        content
            .layoutContent
            .sizing(fitting: size, context: context)
    }

    public func update(with content: FlowReader<Layout>, context: ComponentContext) {
        let proxy = FlowReaderProxy { [weak self] in
            self?.flowView
        }

        let flow = content.viewContent(proxy)

        flowView.update(
            with: flow,
            context: context
        )
    }
}
#endif
