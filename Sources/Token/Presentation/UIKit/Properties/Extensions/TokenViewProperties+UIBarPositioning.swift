#if canImport(UIKit1)
import UIKit

extension TokenViewProperties where View: UIBarPositioning {

    public struct BarPositionMetrics: Hashable {

        public static var any: Self {
            Self(
                barPosition: .any,
                barMetrics: .default
            )
        }

        public let barPosition: UIBarPosition
        public let barMetrics: UIBarMetrics

        public subscript(
            for barPosition: UIBarPosition,
            barMetrics: UIBarMetrics
        ) -> Self {
            Self(
                barPosition: barPosition,
                barMetrics: barMetrics
            )
        }

        public subscript(for barMetrics: UIBarMetrics) -> Self {
            Self(
                barPosition: .any,
                barMetrics: barMetrics
            )
        }
    }

    public struct BarPosition: Hashable {

        public static var any: Self {
            Self(barPosition: .any)
        }

        public let barPosition: UIBarPosition

        public subscript(for barPosition: UIBarPosition) -> Self {
            Self(barPosition: barPosition)
        }
    }
}
#endif
