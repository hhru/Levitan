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

    init() {
        setupDisplayLink()
        subscribeToAppNotifications()
    }
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
        guard let firstFPS, frameCount > 1 else {
            return reset()
        }

        print(
            "Performance:\n",
            "  - target FPS: \(UIScreen.main.maximumFramesPerSecond)",
            "  - first FPS: \(firstFPS)",
            "  - min FPS: \(minFPS)",
            "  - max FPS: \(maxFPS)",
            "  - mean FPS: \(meanFPS)\n",
            "  - hitch duration: \(hitchDuration * 1000.0) ms",
            "  - hitch rate: \(hitchRate) ms / s\n",
            "  - hang duration: \(hangDuration * 1000.0) ms",
            "  - hang rate: \(hangRate) s / h\n",
            separator: "\n"
        )

        reset()
    }
}
