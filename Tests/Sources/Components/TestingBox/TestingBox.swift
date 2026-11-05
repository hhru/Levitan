#if canImport(UIKit)
import Foundation
import Levitan

struct TestingBox: FallbackComponent, Hashable {

    typealias UIView = TestingBoxView

    let sizing: ComponentSizing
}

extension TestingBox: CustomStringConvertible {

    nonisolated var description: String {
        "TestingBox(width: \(sizing.width), height: \(sizing.height))"
    }
}
#endif
