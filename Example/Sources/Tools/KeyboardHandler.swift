import UIKit

protocol KeyboardHandler: NSObject, Sendable {

    @MainActor
    func handleKeyboardFrame(
        animationDuration: TimeInterval,
        animationOptions: UIView.AnimationOptions
    )
}

extension KeyboardHandler {

    @MainActor
    var keyboardFrame: CGRect {
        if let keyboardFrame = keyboardFrameAssociation[self] {
            return keyboardFrame
        }

        let screenBounds = UIScreen.main.bounds

        return CGRect(
            x: screenBounds.minX,
            y: screenBounds.maxY,
            width: screenBounds.width,
            height: .zero
        )
    }

    @MainActor
    func keyboardHeight(in view: UIView) -> CGFloat {
        let bounds = view.window.map { window in
            window.convert(window.bounds, to: nil)
        } ?? UIScreen.main.bounds

        let keyboardFrame = bounds.intersection(keyboardFrame)

        let keyboardHeight = view
            .convert(view.bounds, to: nil)
            .intersection(bounds)
            .maxY - keyboardFrame.minY

        return min(max(keyboardHeight, .zero), keyboardFrame.height)
    }

    @MainActor
    func subscribeToKeyboardNotifications() {
        keyboardWillShowNotificationObserver = NotificationObserver(
            name: UIResponder.keyboardWillShowNotification
        ) { [weak self] notification in
            self?.handleKeyboardFrameNotification(notification)
        }

        keyboardDidShowNotificationObserver = NotificationObserver(
            name: UIResponder.keyboardDidShowNotification
        ) { [weak self] notification in
            self?.handleKeyboardFrameNotification(notification)
        }

        keyboardWillChangeFrameNotificationObserver = NotificationObserver(
            name: UIResponder.keyboardWillChangeFrameNotification
        ) { [weak self] notification in
            self?.handleKeyboardFrameNotification(notification)
        }

        keyboardDidChangeFrameNotificationObserver = NotificationObserver(
            name: UIResponder.keyboardDidChangeFrameNotification
        ) { [weak self] notification in
            self?.handleKeyboardFrameNotification(notification)
        }

        keyboardWillHideNotificationObserver = NotificationObserver(
            name: UIResponder.keyboardWillHideNotification
        ) { [weak self] notification in
            self?.handleKeyboardFrameNotification(notification)
        }

        keyboardDidHideNotificationObserver = NotificationObserver(
            name: UIResponder.keyboardDidHideNotification
        ) { [weak self] notification in
            self?.handleKeyboardFrameNotification(notification)
        }
    }

    @MainActor
    func unsubscribeFromKeyboardNotifications() {
        keyboardWillShowNotificationObserver = nil
        keyboardDidShowNotificationObserver = nil

        keyboardWillChangeFrameNotificationObserver = nil
        keyboardDidChangeFrameNotificationObserver = nil

        keyboardWillHideNotificationObserver = nil
        keyboardDidHideNotificationObserver = nil
    }
}

extension KeyboardHandler {

    private var keyboardWillShowNotificationObserver: NotificationObserver? {
        get { keyboardWillShowNotificationAssociation[self] }
        set { keyboardWillShowNotificationAssociation[self] = newValue }
    }

    private var keyboardDidShowNotificationObserver: NotificationObserver? {
        get { keyboardDidShowNotificationAssociation[self] }
        set { keyboardDidShowNotificationAssociation[self] = newValue }
    }

    private var keyboardWillChangeFrameNotificationObserver: NotificationObserver? {
        get { keyboardWillChangeFrameNotificationAssociation[self] }
        set { keyboardWillChangeFrameNotificationAssociation[self] = newValue }
    }

    private var keyboardDidChangeFrameNotificationObserver: NotificationObserver? {
        get { keyboardDidChangeFrameNotificationAssociation[self] }
        set { keyboardDidChangeFrameNotificationAssociation[self] = newValue }
    }

    private var keyboardWillHideNotificationObserver: NotificationObserver? {
        get { keyboardWillHideNotificationAssociation[self] }
        set { keyboardWillHideNotificationAssociation[self] = newValue }
    }

    private var keyboardDidHideNotificationObserver: NotificationObserver? {
        get { keyboardDidHideNotificationAssociation[self] }
        set { keyboardDidHideNotificationAssociation[self] = newValue }
    }

    private func resolveKeyboardFrame(from notification: Notification) -> CGRect {
        notification
            .userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
            .flatMap { $0 as? NSValue }
            .map { $0.cgRectValue } ?? .zero
    }

    private func resolveKeyboardAnimationDuration(from notification: Notification) -> TimeInterval {
        notification
            .userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]
            .flatMap { $0 as? NSNumber }
            .map { $0.doubleValue } ?? .zero
    }

    private func resolveKeyboardAnimationOptions(from notification: Notification) -> UIView.AnimationOptions {
        notification
            .userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey]
            .flatMap { $0 as? NSNumber }
            .map { $0.intValue }
            .map { UIView.AnimationOptions(rawValue: UInt($0) << 16) } ?? .curveLinear
    }

    private func handleKeyboardFrameNotification(_ notification: Notification) {
        let keyboardFrame = resolveKeyboardFrame(from: notification)

        guard keyboardFrameAssociation[self] != keyboardFrame else {
            return
        }

        keyboardFrameAssociation[self] = keyboardFrame

        let animationDuration = resolveKeyboardAnimationDuration(from: notification)
        let animationOptions = resolveKeyboardAnimationOptions(from: notification)

        MainActor.assumeIsolated {
            handleKeyboardFrame(
                animationDuration: animationDuration,
                animationOptions: animationOptions
            )
        }
    }
}

private let keyboardFrameAssociation = ObjectAssociation<CGRect>()

private let keyboardWillShowNotificationAssociation = ObjectAssociation<NotificationObserver>()
private let keyboardDidShowNotificationAssociation = ObjectAssociation<NotificationObserver>()

private let keyboardWillChangeFrameNotificationAssociation = ObjectAssociation<NotificationObserver>()
private let keyboardDidChangeFrameNotificationAssociation = ObjectAssociation<NotificationObserver>()

private let keyboardWillHideNotificationAssociation = ObjectAssociation<NotificationObserver>()
private let keyboardDidHideNotificationAssociation = ObjectAssociation<NotificationObserver>()
