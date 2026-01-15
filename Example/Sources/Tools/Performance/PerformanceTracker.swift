import Combine
import UIKit

@MainActor
final class PerformanceTracker {

    private enum Thresholds {
        static let hang: TimeInterval = 0.25
    }

    private var displayLink: CADisplayLink?

    private var lastFrameTimestamp: TimeInterval = .zero
    private var lastTargetFrameTimestamp: TimeInterval = .zero

    private var subscriptions: Set<AnyCancellable> = []

    private(set) var duration: TimeInterval = .zero
    private(set) var frameCount: Int = .zero

    private(set) var firstFPS: Double?
    private(set) var minFPS = Double(UIScreen.main.maximumFramesPerSecond)
    private(set) var maxFPS: Double = .zero

    private(set) var hitchDuration: TimeInterval = .zero
    private(set) var hangDuration: TimeInterval = .zero

    var meanFPS: Double {
        duration > .leastNonzeroMagnitude
            ? Double(frameCount) / duration
            : .zero
    }

    var hitchRate: Double {
        duration > .leastNonzeroMagnitude
            ? 1000.0 * hitchDuration / duration
            : .zero
    }

    var hangRate: Double {
        duration > .leastNonzeroMagnitude
            ? 3600.0 * hangDuration / duration
            : .zero
    }

    private init() { }
}

extension PerformanceTracker {

    private func setupDisplayLink() {
        guard displayLink == nil else {
            return
        }

        let displayLink = CADisplayLink(
            target: self,
            selector: #selector(onDisplayLinkUpdate)
        )

        displayLink.add(
            to: .main,
            forMode: .common
        )

        self.displayLink = displayLink

        lastFrameTimestamp = displayLink.timestamp
        lastTargetFrameTimestamp = displayLink.targetTimestamp
    }

    private func resetDisplayLink() {
        displayLink?.remove(
            from: .main,
            forMode: .common
        )

        displayLink = nil
    }

    private func subscribeToAppNotifications() {
        NotificationCenter
            .default
            .publisher(for: UIApplication.didBecomeActiveNotification)
            .sink { [weak self] _ in
                self?.setupDisplayLink()
            }
            .store(in: &subscriptions)

        NotificationCenter
            .default
            .publisher(for: UIApplication.willResignActiveNotification)
            .sink { [weak self] _ in
                self?.resetDisplayLink()
            }
            .store(in: &subscriptions)
    }

    private func unsubscribeFromAppNotifications() {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    @objc
    private func onDisplayLinkUpdate(_ displayLink: CADisplayLink) {
        defer {
            lastFrameTimestamp = displayLink.timestamp
            lastTargetFrameTimestamp = displayLink.targetTimestamp
        }

        guard lastFrameTimestamp > .leastNonzeroMagnitude else {
            return
        }

        let frameTimestamp = max(displayLink.timestamp, lastTargetFrameTimestamp)
        let frameDuration = frameTimestamp - lastFrameTimestamp

        guard frameDuration > .leastNonzeroMagnitude else {
            return
        }

        if firstFPS == nil {
            return firstFPS = 1.0 / frameDuration
        }

        duration += frameDuration
        frameCount += 1

        let currentFPS = 1.0 / frameDuration

        if minFPS > currentFPS {
            minFPS = currentFPS
        }

        if maxFPS < currentFPS {
            maxFPS = currentFPS
        }

        if frameDuration > Thresholds.hang {
            hangDuration += frameDuration - Thresholds.hang
        } else {
            hitchDuration += max(displayLink.timestamp - lastTargetFrameTimestamp, .zero)
        }
    }
}

extension PerformanceTracker {

    static let shared = PerformanceTracker()

    func showMonitor(for windowScene: UIWindowScene? = nil) {
        let windowScene = windowScene ?? UIApplication
            .shared
            .connectedScenes
            .lazy
            .compactMap { $0 as? UIWindowScene }
            .first

        guard let windowScene else {
            return assertionFailure("UIWindowScene was not found")
        }

        let window = PerformanceMonitorWindow(windowScene: windowScene)

        window.rootViewController = PerformanceMonitorController(window: window)
        window.windowLevel = .alert + 1.0
        window.isHidden = false
    }

    func hideMonitor(for windowScene: UIWindowScene? = nil) {
        let windows: [UIWindow]

        if let windowScene {
            windows = windowScene.windows
        } else {
            windows = UIApplication
                .shared
                .connectedScenes
                .lazy
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
        }

        for window in windows where window is PerformanceMonitorWindow {
            window.rootViewController = nil
        }
    }

    func start() {
        setupDisplayLink()
        subscribeToAppNotifications()
    }

    func stop() {
        unsubscribeFromAppNotifications()
        resetDisplayLink()
    }

    func reset() {
        duration = .zero
        frameCount = .zero

        firstFPS = nil
        minFPS = Double(UIScreen.main.maximumFramesPerSecond)
        maxFPS = .zero

        hitchDuration = .zero
        hangDuration = .zero
    }

    func track() {
        guard frameCount > 1 else {
            return reset()
        }

        let targetFPS = String(format: "%.1f", UIScreen.main.maximumFramesPerSecond)
        let firstFPS = firstFPS.map { String(format: "%.2f", $0) } ?? "n/a"
        let minFPS = String(format: "%.1f", minFPS)
        let maxFPS = String(format: "%.1f", maxFPS)
        let meanFPS = String(format: "%.1f", meanFPS)

        let hitchDuration = String(format: "%.2f ms", hitchDuration * 1000.0)
        let hitchRate = String(format: "%.2f ms/s", hitchRate)

        let hangDuration = String(format: "%.2f ms", hangDuration * 1000.0)
        let hangRate = String(format: "%.2f s/h", hangRate)

        print(
            "Performance:\n",
            "  - target FPS: \(targetFPS)",
            "  - first Frame: \(firstFPS)",
            "  - min FPS: \(minFPS)",
            "  - max FPS: \(maxFPS)",
            "  - mean FPS: \(meanFPS)\n",
            "  - hitch duration: \(hitchDuration)",
            "  - hitch rate: \(hitchRate)\n",
            "  - hang duration: \(hangDuration)",
            "  - hang rate: \(hangRate)\n",
            separator: "\n"
        )

        reset()
    }
}
