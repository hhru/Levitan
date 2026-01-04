import UIKit

struct ActionSheetAction {

    let title: String

    let style: UIAlertAction.Style

    let handler: (() -> Void)?

    init(
        title: String,
        style: UIAlertAction.Style = .default,
        handler: (() -> Void)? = nil
    ) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}

extension ActionSheetAction {

    static func cancel(title: String) -> Self {
        Self(title: title, style: .cancel)
    }
}
