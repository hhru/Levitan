#if canImport(UIKit)
import UIKit
import SwiftUI

/// UIKit-представление компонента-обертки со стертым типом.
public class AnyComponentView: UIView {

    private var contentView: UIView?

    public override var intrinsicContentSize: CGSize {
        contentView?.intrinsicContentSize ?? super.intrinsicContentSize
    }

    public override var canBecomeFirstResponder: Bool {
        contentView?.canBecomeFirstResponder ?? super.canBecomeFirstResponder
    }

    public override var canResignFirstResponder: Bool {
        contentView?.canResignFirstResponder ?? super.canResignFirstResponder
    }

    public override var isFirstResponder: Bool {
        contentView?.isFirstResponder ?? super.isFirstResponder
    }

    @discardableResult
    public override func becomeFirstResponder() -> Bool {
        contentView?.becomeFirstResponder() ?? super.becomeFirstResponder()
    }

    @discardableResult
    public override func resignFirstResponder() -> Bool {
        contentView?.resignFirstResponder() ?? super.resignFirstResponder()
    }

    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let contentView else {
            return super.hitTest(point, with: event)
        }

        return contentView.hitTest(point, with: event)
    }

    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let contentView else {
            return super.point(inside: point, with: event)
        }

        return contentView.point(inside: point, with: event)
    }
}

extension AnyComponentView: ComponentView {

    public func update(with content: AnyComponent, context: ComponentContext) {
        let presenter = content.presenter

        let contentView = contentView.flatMap { contentView in
            presenter.updateContentView(contentView, context: context)
        }

        if self.contentView !== contentView {
            self.contentView?.removeFromSuperview()
        }

        if let contentView {
            self.contentView = contentView
        } else {
            self.contentView = presenter.makeContentView(
                for: self,
                context: context
            )
        }

        invalidateIntrinsicContentSize()
    }
}
#endif
