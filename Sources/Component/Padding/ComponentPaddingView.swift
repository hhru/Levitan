#if canImport(UIKit)
import UIKit

/// UIKit-представление контейнера для добавления отступов.
///
/// Используется только при встраивании контейнера в другое UIKit-представление
/// для минимизации лишних UI-представлений в иерархии.
///
/// - SeeAlso: ``ComponentPadding``
/// - SeeAlso: ``Component``
public final class ComponentPaddingView<Content: Component>: UIView {

    private let contentView = Content.UIView()

    private var contentConstraints: [NSLayoutConstraint] = []
    private var contentInsets: UIEdgeInsets?

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setupContentView()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupContentView() {
        addSubview(contentView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func layoutContentView(insets: UIEdgeInsets) {
        NSLayoutConstraint.deactivate(contentConstraints)

        contentConstraints = [
            contentView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: insets.top
            ),
            contentView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: insets.left
            ),
            contentView.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -insets.bottom
            ),
            contentView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -insets.right
            )
        ]

        NSLayoutConstraint.activate(contentConstraints)
    }

    private func layoutContentViewIfNeeded(insets: UIEdgeInsets) {
        guard contentInsets != insets else {
            return
        }

        contentInsets = insets

        layoutContentView(insets: insets)
    }
}

extension ComponentPaddingView: ComponentView {

    public func update(with content: ComponentPadding<Content>, context: ComponentContext) {
        layoutContentViewIfNeeded(insets: content.insets.uiEdgeInsets)

        contentView.update(
            with: content.content,
            context: context
        )
    }
}
#endif
