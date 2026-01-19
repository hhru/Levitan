import Foundation

extension Task where Success == Never, Failure == Never {

    public static func sleep(seconds: Double) async throws {
        try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }
}
