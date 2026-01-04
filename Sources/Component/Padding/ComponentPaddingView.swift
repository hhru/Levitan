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
    private var contentInsetsToken: InsetsToken?
    private var contentInsetsValue: InsetsValue?

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setupContentView()

        tokens.customBinding { view, theme in
            if let insetsValue = view.contentInsetsToken?.resolve(for: theme) {
                view.layoutContentViewIfNeeded(insetsValue: insetsValue)
            }
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

    private func layoutContentView(insetsValue: InsetsValue) {
        NSLayoutConstraint.deactivate(contentConstraints)

        contentConstraints = [
            contentView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: insetsValue.top
            ),
            contentView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: insetsValue.leading
            ),
            contentView.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -insetsValue.bottom
            ),
            contentView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -insetsValue.trailing
            )
        ]

        NSLayoutConstraint.activate(contentConstraints)
    }

    private func layoutContentViewIfNeeded(insetsValue: InsetsValue) {
        guard contentInsetsValue != insetsValue else {
            return
        }

        contentInsetsValue = insetsValue

        layoutContentView(insetsValue: insetsValue)
    }

    private func layoutContentViewIfNeeded(insetsToken: InsetsToken) {
        guard contentInsetsToken != insetsToken else {
            return
        }

        contentInsetsToken = insetsToken

        layoutContentViewIfNeeded(insetsValue: insetsToken.resolve(for: tokens.theme))
    }
}

extension ComponentPaddingView: ComponentView {

    public func update(with content: ComponentPadding<Content>, context: ComponentContext) {
        layoutContentViewIfNeeded(insetsToken: content.insets ?? .zero)

        contentView.update(
            with: content.content,
            context: context
        )
    }
}
#endif
