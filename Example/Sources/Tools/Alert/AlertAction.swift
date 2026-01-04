import UIKit

struct AlertAction {

    let title: String
    let style: UIAlertAction.Style
    let handler: ((_ texts: [String]) -> Void)?

    init(
        title: String,
        style: UIAlertAction.Style = .default,
        handler: ((_ texts: [String]) -> Void)? = nil
    ) {
        self.title = title
        self.style = style
        self.handler = handler
    }

    init(
        title: String,
        style: UIAlertAction.Style = .default,
        handler: (() -> Void)?
    ) {
        self.init(title: title, style: style) { _ in
            handler?()
        }
    }
}

extension AlertAction {

    static func cancel(title: String) -> Self {
        Self(title: title, style: .cancel)
    }
}
