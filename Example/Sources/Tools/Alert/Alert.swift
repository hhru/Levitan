import Levitan
import UIKit

struct Alert {

    let title: String?
    let message: String?

    let textFields: [AlertTextField]
    let actions: [AlertAction]

    init(
        title: String?,
        message: String? = nil,
        textFields: [AlertTextField] = [],
        actions: [AlertAction] = []
    ) {
        self.title = title
        self.message = message

        self.textFields = textFields
        self.actions = actions
    }

    init(
        title: String?,
        message: String? = nil,
        textFields: [AlertTextField] = [],
        @ViewArrayBuilder<AlertAction> actions: () -> [AlertAction]
    ) {
        self.init(
            title: title,
            message: message,
            textFields: textFields,
            actions: actions()
        )
    }
}

extension UIViewController {

    func showAlert(_ alert: Alert, animated: Bool = true) {
        let alertController = UIAlertController(
            title: alert.title,
            message: alert.message,
            preferredStyle: .alert
        )

        if let tintColor = UIColor(named: "AccentColor") {
            alertController.view.tintColor = tintColor
        }

        var uiTextFields: [UITextField] = []

        for textField in alert.textFields {
            alertController.addTextField { uiTextField in
                uiTextFields.append(uiTextField)

                uiTextField.text = textField.text
                uiTextField.placeholder = textField.placeholder
            }
        }

        let actions = alert.actions.map { action in
            UIAlertAction(title: action.title, style: action.style) { _ in
                action.handler?(uiTextFields.map { $0.text ?? "" })
            }
        }

        for action in actions {
            alertController.addAction(action)
        }

        return present(alertController, animated: animated)
    }
}
