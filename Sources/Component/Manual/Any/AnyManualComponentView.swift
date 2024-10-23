//
//  Created on 11.04.2024.
//  Copyright © HeadHunter. All rights reserved.
//

import UIKit

/// UIKit-представление компонента-обертки со стертым типом.
public final class AnyManualComponentView: UIView {

    private let wrappedView = AnyComponentView()

    public override var intrinsicContentSize: CGSize {
        wrappedView.intrinsicContentSize
    }

    public override var canBecomeFirstResponder: Bool {
        wrappedView.canBecomeFirstResponder
    }

    public override var canResignFirstResponder: Bool {
        wrappedView.canResignFirstResponder
    }

    public override var isFirstResponder: Bool {
        wrappedView.isFirstResponder
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(wrappedView)

        wrappedView.translatesAutoresizingMaskIntoConstraints = false

        wrappedView
            .topAnchor
            .constraint(equalTo: topAnchor)
            .activate()

        wrappedView
            .leadingAnchor
            .constraint(equalTo: leadingAnchor)
            .activate()

        wrappedView
            .bottomAnchor
            .constraint(equalTo: bottomAnchor)
            .activate()

        wrappedView
            .trailingAnchor
            .constraint(equalTo: trailingAnchor)
            .activate()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @discardableResult
    public override func becomeFirstResponder() -> Bool {
        wrappedView.becomeFirstResponder()
    }

    @discardableResult
    public override func resignFirstResponder() -> Bool {
        wrappedView.resignFirstResponder()
    }

    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        wrappedView.hitTest(point, with: event)
    }

    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        wrappedView.point(inside: point, with: event)
    }
}

extension AnyManualComponentView: ComponentView {

    public func update(with content: AnyManualComponent, context: ComponentContext) {
        wrappedView.update(with: content.wrapped, context: context)

        invalidateIntrinsicContentSize()
    }
}
