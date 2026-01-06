import Levitan
import UIKit

class ChatInputView: UIView {

    private let stackView = UIStackView()
    private let textView = UITextView()
    private let sendButton = ChatInputButton.UIView()

    private var content: Content?
    private var context: ComponentContext?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupStackView()
        setupTextView()
        setupSendButton()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupStackView() {
        addSubview(stackView)

        stackView.axis = .horizontal
        stackView.spacing = 8.0
        stackView.alignment = .top

        stackView.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    private func setupTextView() {
        stackView.addArrangedSubview(textView)

        textView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textView.setContentHuggingPriority(.defaultLow, for: .vertical)

        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

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

        textView.tokens.corners = .rounded(radius: 12.0)
        textView.tokens.stroke = Strokes.inside.color(Colors.stroke)
    }

    private func setupSendButton() {
        stackView.addArrangedSubview(sendButton)

        sendButton.setContentHuggingPriority(.required, for: .horizontal)
        sendButton.setContentHuggingPriority(.required, for: .vertical)

        sendButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        sendButton.setContentCompressionResistancePriority(.required, for: .vertical)

        sendButton
            .heightAnchor
            .constraint(lessThanOrEqualTo: textView.heightAnchor)
            .isActive = true

        sendButton.tokens.backgroundColor = Colors.background.pressed
        sendButton.tokens.corners = .rounded(radius: 12.0)
        sendButton.tokens.stroke = Strokes.outside.color(Colors.stroke)
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
