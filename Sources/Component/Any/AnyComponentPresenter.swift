#if canImport(UIKit)
import UIKit
import SwiftUI

@MainActor
internal struct AnyComponentPresenter {

    private let makeContentViewBox: (
        _ containerView: UIView,
        _ context: ComponentContext
    ) -> UIView

    private let updateContentViewBox: (
        _ contentView: UIView,
        _ context: ComponentContext
    ) -> UIView?

    internal init<Content: Component>(content: Content)
    where Content.UIView.Content == Content {
        makeContentViewBox = { containerView, context in
            let contentView = Content.UIView(frame: containerView.bounds)

            contentView.translatesAutoresizingMaskIntoConstraints = false
            contentView.frame = containerView.bounds

            containerView.addSubview(contentView)

            let constraints = [
                contentView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                contentView.topAnchor.constraint(equalTo: containerView.topAnchor),
                contentView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                contentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ]

            NSLayoutConstraint.activate(constraints)

            contentView.update(
                with: content,
                context: context
            )

            return contentView
        }

        updateContentViewBox = { contentView, context in
            guard let contentView = contentView as? Content.UIView else {
                return nil
            }

            contentView.update(
                with: content,
                context: context
            )

            return contentView
        }
    }

    internal func makeContentView(
        for containerView: UIView,
        context: ComponentContext
    ) -> UIView {
        makeContentViewBox(containerView, context)
    }

    internal func updateContentView(
        _ contentView: UIView,
        context: ComponentContext
    ) -> UIView? {
        updateContentViewBox(contentView, context)
    }
}

extension Component {

    #if swift(<6.0)
    @MainActor
    #endif
    internal func eraseToAnyComponentPresenter() -> AnyComponentPresenter {
        AnyComponentPresenter(content: self)
    }
}
#endif
