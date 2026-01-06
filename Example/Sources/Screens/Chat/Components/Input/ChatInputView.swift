import Levitan
import UIKit

class ChatInputView: UIView {

    private let textView = UITextView()
    private let sendButton = ChatInputButton.UIView()

    private var content: Content?
    private var context: ComponentContext?

    override init(frame: CGRect) {
        super.init(frame: frame)

        tokens.backgroundColor = Colors.background.default
        tokens.corners = .rounded(radius: 16.0)
        tokens.stroke = Strokes.outside.color(Colors.stroke)

        setupTextView()
        setupSendButton()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTextView() {
        addSubview(textView)

        textView.textContainerInset = UIEdgeInsets(
            top: 8.0,
            left: 12.0,
            bottom: 8.0,
            right: 12.0
        )

        textView.isScrollEnabled = false
        textView.delegate = self

        let typography = Typographies
            .label2
            .foregroundColor(Colors.text.primary)

        textView.tokens.tintColor = Colors.accent
        textView.tokens.textColor = Colors.text.primary
        textView.tokens.textFont = typography.font
        textView.tokens.typingAttributes = typography
        textView.tokens.corners = .rounded(radius: 20.0)
        textView.tokens.stroke = Strokes.inside.color(Colors.stroke)

        textView.translatesAutoresizingMaskIntoConstraints = false

        textView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textView.setContentHuggingPriority(.defaultHigh, for: .vertical)

        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)

        textView
            .leadingAnchor
            .constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 12.0)
            .activate()

        textView
            .topAnchor
            .constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12.0)
            .activate()

        textView
            .bottomAnchor
            .constraint(equalTo: keyboardLayoutGuide.topAnchor, constant: -12.0)
            .activate()
    }

    private func setupSendButton() {
        addSubview(sendButton)

        sendButton.translatesAutoresizingMaskIntoConstraints = false

        sendButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        sendButton.setContentHuggingPriority(.defaultHigh, for: .vertical)

        sendButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        sendButton.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)

        sendButton
            .heightAnchor
            .constraint(lessThanOrEqualTo: textView.heightAnchor)
            .activate()

        sendButton
            .leadingAnchor
            .constraint(equalTo: textView.trailingAnchor, constant: 8.0)
            .activate()

        sendButton
            .topAnchor
            .constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12.0)
            .activate()

        sendButton
            .trailingAnchor
            .constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -12.0)
            .activate()
    }

    private func updateSendButton() {
        guard let content, let context else {
            return
        }

        let sendAction = content.sendAction

        let isDisabled = content
            .text
            .trimmingCharacters(in: .whitespaces)
            .isEmpty

        sendButton.update(
            with: ChatInputButton(tapAction: sendAction),
            context: context.disabled(isDisabled)
        )
    }
}

extension ChatInputView: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        content?.text = textView.text ?? ""
    }
}

extension ChatInputView: FallbackComponentView {

    static func sizing(
        for content: ChatInput,
        fitting size: CGSize,
        context: ComponentContext
    ) -> ComponentSizing {
        ComponentSizing(width: .fill, height: .hug)
    }

    func update(with content: ChatInput, context: ComponentContext) {
        self.content = content
        self.context = context

        textView.text = content.text

        updateSendButton()
    }
}
