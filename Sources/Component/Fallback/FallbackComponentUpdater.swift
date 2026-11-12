#if canImport(UIKit)
import Foundation

@MainActor
internal enum FallbackComponentUpdater {

    private static var counter = 0

    internal static var isPerforming: Bool {
        counter > 0
    }

    internal static func perform(_ update: () -> Void) {
        counter += 1
        update()
        counter -= 1
    }
}
#endif
