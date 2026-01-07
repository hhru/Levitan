import Combine
import Levitan
import UIKit

final class ChatViewController: UIViewController {

    let userID: Int

    private let chatsStore = ChatsStore.shared
    private var chatsSubscription: AnyCancellable?

    private let usersStore = UsersStore.shared
    private var usersSubscription: AnyCancellable?

    private var context = ComponentContext.default

    private let contentView = VerticalFlow.UIView()
    private let chatInputView = ChatInput.UIView()

    private var chatInputText = "" {
        didSet { updateChatInputView() }
    }

    init(userID: Int) {
        self.userID = userID

        super.init(nibName: nil, bundle: nil)

        hidesBottomBarWhenPushed = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.tokens.backgroundColor = Colors.background.default

        context = context
            .componentViewController(self)
            .fallbackComponentSizeCache(FallbackComponentSizeCache())

        setupNavigationBar()
        setupContentView()
        setupChatInputView()

        updateChatInputView()

        usersSubscription = usersStore
            .usersPublisher
            .sink { [weak self] _ in
                self?.updateNavigationBar()
            }

        chatsSubscription = chatsStore
            .chatsPublisher
            .sink { [weak self] _ in
                self?.updateFlowView()
            }

        subscribeToKeyboardNotifications()
    }
}

extension ChatViewController: KeyboardHandler {

    public func handleKeyboardFrame(
        animationDuration: TimeInterval,
        animationOptions: UIView.AnimationOptions
    ) {
        UIView.animate(
            withDuration: animationDuration,
            delay: .zero,
            options: [animationOptions, .beginFromCurrentState],
            animations: {
                self.view.layoutIfNeeded()
                self.updateFlowViewInsets()
            }
        )
    }
}

extension ChatViewController {

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Reset",
            style: .plain,
            target: self,
            action: #selector(onResetChatsTap)
        )
    }

    private func setupContentView() {
        view.addSubview(contentView)

        contentView.keyboardDismissMode = .interactive
        contentView.contentInsetAdjustmentBehavior = .always
        contentView.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    private func setupChatInputView() {
        view.addSubview(chatInputView)

        chatInputView.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            chatInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chatInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chatInputView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    private func updateNavigationBar() {
        navigationItem.title = usersStore
            .user(id: userID)?
            .name ?? "Unknown user"
    }

    private func updateFlowView() {
        let messages = chatsStore.chat(userID: userID)?.messages ?? []

        let messageGroupes = Dictionary(
            grouping: messages,
            by: { Calendar.current.startOfDay(for: $0.date) }
        )

        let sections = messageGroupes
            .keys
            .sorted()
            .compactMap { messageGroupes[$0] }
            .compactMap { chatMessageSection(messages: $0) }

        let content = VerticalFlow(sections: sections)
            .scrollAnchor(.bottomLeading)
            .pinnedViews(.header)

        contentView.update(
            with: content,
            context: context
        )
    }

    private func updateFlowViewInsets() {
        contentView.contentInsets.bottom = contentView
            .frame
            .intersection(chatInputView.frame)
            .height - contentView.safeAreaInsets.bottom
    }

    private func updateChatInputView() {
        let text = ViewBinding(
            get: { [weak self] in
                self?.chatInputText ?? ""
            },
            set: { [weak self] text in
                self?.chatInputText = text
            }
        )

        let chatInput = ChatInput(
            text: text,
            sendAction: { [weak self] in
                self?.onSendMessageTap()
            }
        )

        chatInputView.update(
            with: chatInput,
            context: context
        )

        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
            self.updateFlowViewInsets()
        }
    }
}

extension ChatViewController {

    private func chatMessageSection(messages: [ChatMessage]) -> VerticalFlowSection? {
        guard let date = messages.first?.date else {
            return nil
        }

        let header = ChatHeader(date: date, info: nil)
            .padding(top: 16.0, bottom: 8.0)
            .frame(width: .fill)
            .flowHeader()

        return VerticalFlowSection(identifier: date) {
            messages.map { message in
                chatMessageItem(message: message)
            }
        }
        .header(header)
        .verticalSpacing(8.0)
    }

    private func chatMessageItem(message: ChatMessage) -> any FlowItem {
        switch message.type {
        case .incoming:
            chatIncomingMessageItem(message: message)

        case .outgoing:
            chatOutgoingMessageItem(message: message)
        }
    }

    private func chatIncomingMessageItem(message: ChatMessage) -> any FlowItem {
        ChatIncomingMessage(
            text: message.text,
            time: message.date,
            tapAction: { [weak self] in
                self?.onChatMessageTap(messageID: message.id)
            }
        )
        .padding(top: 8.0)
        .flowItem(identifier: message.id)
    }

    private func chatOutgoingMessageItem(message: ChatMessage) -> any FlowItem {
        ChatOutgoingMessage(
            text: message.text,
            time: message.date,
            tapAction: { [weak self] in
                self?.onChatMessageTap(messageID: message.id)
            }
        )
        .padding(top: 8.0)
        .flowItem(identifier: message.id)
    }
}

extension ChatViewController {

    @objc private func onResetChatsTap() {
        chatsStore.updateChats(with: Chat.all)
    }

    private func onChatMessageTap(messageID: UUID) {
        guard let message = chatsStore.chat(userID: userID)?.message(id: messageID) else {
            return
        }

        let actionSheet = ActionSheet {
            ActionSheetAction(title: "Add message before") {
                let date = message
                    .date
                    .addingTimeInterval(-0.01)

                self.onInsertMessageTap(date: date)
            }

            ActionSheetAction(title: "Add message after") {
                let date = message
                    .date
                    .addingTimeInterval(0.01)

                self.onInsertMessageTap(date: date)
            }

            ActionSheetAction(title: "Edit message") {
                self.onEditMessageTap(messageID: messageID)
            }

            ActionSheetAction(title: "Remove message", style: .destructive) {
                self.chatsStore.removeChatMessage(
                    userID: self.userID,
                    messageID: messageID
                )
            }

            ActionSheetAction.cancel(title: "Cancel")
        }

        showActionSheet(actionSheet)
    }

    private func onEditMessageTap(messageID: UUID) {
        let text = chatsStore
            .chat(userID: userID)?
            .message(id: messageID)?
            .text

        let alert = Alert.textEditor(
            title: "Message",
            text: text,
            placeholder: "Text",
            saveAction: { text in
                self.chatsStore.updateChatMessage(
                    userID: self.userID,
                    messageID: messageID,
                    text: text
                )
            }
        )

        showAlert(alert)
    }

    private func onInsertMessageTap(date: Date) {
        let textField = AlertTextField(
            text: "",
            placeholder: "Text"
        )

        let alert = Alert(title: "New message", textFields: [textField]) {
            AlertAction(title: "Add incoming message") { texts in
                self.chatsStore.insertChatIncomingMessage(
                    userID: self.userID,
                    text: texts.first ?? "",
                    date: date
                )
            }

            AlertAction(title: "Add outgoing message") { texts in
                self.chatsStore.insertChatOutgoingMessage(
                    userID: self.userID,
                    text: texts.first ?? "",
                    date: date
                )
            }

            AlertAction.cancel(title: "Cancel")
        }

        showAlert(alert)
    }

    private func onSendMessageTap() {
        chatsStore.insertChatOutgoingMessage(
            userID: self.userID,
            text: chatInputText,
            date: Date()
        )

        chatInputText = ""
    }
}
