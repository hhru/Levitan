import Foundation

class NotificationObserver {

    private var token: NSObjectProtocol?

    let center: NotificationCenter
    let name: Notification.Name
    let queue: OperationQueue?
    let handler: (@Sendable (_ notification: Notification) -> Void)?

    init(
        center: NotificationCenter = .default,
        name: Notification.Name,
        queue: OperationQueue? = nil,
        handler: (@Sendable (_ notification: Notification) -> Void)?
    ) {
        self.center = center
        self.name = name
        self.queue = queue
        self.handler = handler

        self.token = center.addObserver(forName: name, object: nil, queue: queue) { notification in
            handler?(notification)
        }
    }

    deinit {
        if let token {
            center.removeObserver(token)
        }
    }
}
