#if canImport(UIKit)
import UIKit

public final class ComponentPaddingView<Content: Component>: UIView {

    private let contentView = Content.UIView()
    private var contentViewConstraints: [NSLayoutConstraint] = []
    private var contentInsets: InsetsToken?

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setupContentView()

        tokens.customBinding { view, theme in
            view.layoutContentView(theme: theme)
        }
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupContentView() {
        addSubview(contentView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func layoutContentView(theme: TokenTheme) {
        NSLayoutConstraint.deactivate(contentViewConstraints)

        let insets = contentInsets?.resolve(for: theme) ?? .zero

        contentViewConstraints = [
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.leading),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.trailing)
        ]

        NSLayoutConstraint.activate(contentViewConstraints)
    }
}

extension ComponentPaddingView: ComponentView {

    public func update(with content: ComponentPadding<Content>, context: ComponentContext) {
        contentInsets = content.insets

        contentView.update(
            with: content.content,
            context: context
        )

        layoutContentView(theme: tokens.theme)
    }
}
#endif
