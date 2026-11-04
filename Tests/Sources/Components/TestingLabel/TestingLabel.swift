#if canImport(UIKit)
import Levitan
import UIKit

struct TestingLabel: FallbackComponent, Hashable {

    typealias UIView = TestingLabelView

    let text = "Без ограничений этот текст тянется в одну длинную строку"
    let sizing: ComponentSizing
}

extension TestingLabel: CustomStringConvertible {

    nonisolated var description: String {
        "TestingLabel(width: \(sizing.width), height: \(sizing.height))"
    }
}
#endif
