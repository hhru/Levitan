import UIKit

final class PerformanceMonitor: UIView {

    private let tracker = PerformanceTracker.shared

    private let contentView = UIView()
    private let stackView = UIStackView()
    private let fpsLabel = UILabel()
    private let hitchesLabel = UILabel()
    private let hangsLabel = UILabel()

    private var contentViewCenterXConstraint: NSLayoutConstraint?
    private var contentViewTopConstraint: NSLayoutConstraint?

    private var updateTimer: Timer?
    private var lastDuration: TimeInterval = .zero
    private var lastFrameCount: Int = .zero

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupContentView()
        setupStackView()

        setupTextLabel(fpsLabel)
        setupTextLabel(hitchesLabel)
        setupTextLabel(hangsLabel)

        translatesAutoresizingMaskIntoConstraints = false
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        super
            .hitTest(point, with: event)
            .flatMap { $0 === self ? nil : $0 }
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()

        guard window == nil else {
            return
        }

        updateTimer?.invalidate()
        updateTimer = nil
    }

    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)

        guard newWindow != nil else {
            return
        }

        contentView.isHidden = true

        lastDuration = tracker.duration
        lastFrameCount = tracker.frameCount

        let timer = Timer(timeInterval: 1.0, repeats: true) { [weak self] _ in
            MainActor.assumeIsolated {
                self?.updateTextLabels()
            }
        }

        RunLoop.current.add(timer, forMode: .common)

        updateTimer = timer
    }
}

extension PerformanceMonitor {

    @objc
    private func onContentPanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)

        contentViewCenterXConstraint?.constant += translation.x
        contentViewTopConstraint?.constant += translation.y

        gesture.setTranslation(.zero, in: self)
    }

    private func setupContentView() {
        addSubview(contentView)

        contentView.isHidden = true
        contentView.backgroundColor = .black
        contentView.alpha = 0.75

        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.borderWidth = 1.0 / UIScreen.main.scale
        contentView.layer.cornerRadius = 8.0

        contentView.translatesAutoresizingMaskIntoConstraints = false

        contentViewCenterXConstraint = contentView
            .centerXAnchor
            .constraint(equalTo: centerXAnchor)
            .activate()

        contentViewTopConstraint = contentView
            .topAnchor
            .constraint(equalTo: safeAreaLayoutGuide.topAnchor)
            .activate()

        let contentPanGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(onContentPanGesture)
        )

        contentView.addGestureRecognizer(contentPanGesture)
    }

    private func setupStackView() {
        addSubview(stackView)

        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 2.0
        stackView.isUserInteractionEnabled = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            stackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 8.0
            ),
            stackView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 4.0
            ),
            stackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -8.0
            ),
            stackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -4.0
            )
        ]

        NSLayoutConstraint.activate(constraints)
    }

    private func setupTextLabel(_ textLabel: UILabel) {
        stackView.addArrangedSubview(textLabel)

        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = .monospacedSystemFont(ofSize: 8.0, weight: .medium)
        textLabel.textColor = .white
    }

    private func updateTextLabels() {
        let durationDelta = tracker.duration - lastDuration
        let frameCountDelta = tracker.frameCount - lastFrameCount

        let currentFPS = String(format: "%.1f", Double(frameCountDelta) / durationDelta)
        let minFPS = String(format: "%.1f", tracker.minFPS)
        let maxFPS = String(format: "%.1f", tracker.maxFPS)

        let hitchDuration = String(format: "%.2f ms", tracker.hitchDuration * 1000.0)
        let hitchRate = String(format: "%.2f ms/s", tracker.hitchRate)

        let hangDuration = String(format: "%.2f ms", tracker.hangDuration * 1000.0)
        let hangRate = String(format: "%.2f s/h", tracker.hangRate)

        fpsLabel.text = "    FPS: \(currentFPS) (min: \(minFPS) max: \(maxFPS))"
        hitchesLabel.text = "Hitches: \(hitchDuration) (rate: \(hitchRate))"
        hangsLabel.text = "  Hangs: \(hangDuration) (rate: \(hangRate))"

        lastDuration = tracker.duration
        lastFrameCount = tracker.frameCount

        contentView.isHidden = false
    }
}
