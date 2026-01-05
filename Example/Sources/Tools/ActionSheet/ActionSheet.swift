import Levitan
import UIKit

struct ActionSheet {

    let title: String?
    let message: String?
    let actions: [ActionSheetAction]

    init(
        title: String? = nil,
        message: String? = nil,
        actions: [ActionSheetAction] = []
    ) {
        self.title = title
        self.message = message
        self.actions = actions
    }

    init(
        title: String? = nil,
        message: String? = nil,
        @ViewArrayBuilder<ActionSheetAction> actions: () -> [ActionSheetAction]
    ) {
        self.init(
            title: title,
            message: message,
            actions: actions()
        )
    }
}

extension UIViewController {

    func showActionSheet(_ actionSheet: ActionSheet, animated: Bool = true) {
        let alertController = UIAlertController(
            title: actionSheet.title,
            message: actionSheet.message,
            preferredStyle: .actionSheet
        )

        if let tintColor = UIColor(named: "AccentColor") {
            alertController.view.tintColor = tintColor
        }

        let actions = actionSheet.actions.map { action in
            UIAlertAction(title: action.title, style: action.style) { _ in
                action.handler?()
            }
        }

        for action in actions {
            alertController.addAction(action)
        }

        return present(alertController, animated: animated)
    }
}
