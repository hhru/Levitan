import Foundation

internal final class DifferenceStageSections<Section: DiffableSection> {

    internal var firstStageSections: [Section]
    internal var secondStageSections: [Section]
    internal var thirdStageSections: [Section]
    internal var fourthStageSections: [Section]

    internal init(
        firstStageSections: [Section],
        secondStageSections: [Section] = [],
        thirdStageSections: [Section] = [],
        fourthStageSections: [Section] = []
    ) {
        self.firstStageSections = firstStageSections
        self.secondStageSections = secondStageSections
        self.thirdStageSections = thirdStageSections
        self.fourthStageSections = fourthStageSections
    }
}
