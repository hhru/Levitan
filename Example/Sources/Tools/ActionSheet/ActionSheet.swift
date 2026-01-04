import UIKit

struct ActionSheet {

    let title: String?
    let message: String?
    let tintColor: UIColor?
    let actions: [ActionSheetAction]

    init(
        title: String? = nil,
        message: String? = nil,
        tintColor: UIColor? = nil,
        actions: [ActionSheetAction] = []
    ) {
        self.title = title
        self.message = message
        self.tintColor = tintColor
        self.actions = actions
    }
}

extension UIViewController {

    func showActionSheet(_ actionSheet: ActionSheet, animated: Bool = true) {
        let alertController = UIAlertController(
            title: actionSheet.title,
            message: actionSheet.message,
            preferredStyle: .actionSheet
        )

        if let tintColor = actionSheet.tintColor {
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
