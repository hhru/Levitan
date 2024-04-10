import Foundation

internal final class SectionDifferenceCalculator {

    // swiftlint:disable:next function_body_length
    internal func calculateDifference<Section: DiffableSection>(
        from sourceSections: [Section],
        to targetSections: [Section]
    ) -> SectionDifferenceChangeset {
        var deleted: [Int] = []
        var inserted: [Int] = []
        var updated: [Int] = []
        var moved: [DifferenceMotion<Int>] = []

        var sourceTraces = ContiguousArray<DifferenceTrace<Int>>()
        var sourceIdentifiers = ContiguousArray<AnyHashable>()

        var targetReferences = ContiguousArray<Int?>(repeating: nil, count: targetSections.count)

        sourceTraces.reserveCapacity(sourceSections.count)
        sourceIdentifiers.reserveCapacity(sourceSections.count)

        for sourceElement in sourceSections {
            sourceTraces.append(DifferenceTrace())
            sourceIdentifiers.append(sourceElement.differenceIdentifier)
        }

        // swiftlint:disable:next closure_body_length
        sourceIdentifiers.withUnsafeBufferPointer { bufferPointer in
            var sourceOccurrencesDictionary = [DifferenceDictionaryKey: DifferenceOccurrence](
                minimumCapacity: sourceSections.count
            )

            for sourceIndex in sourceIdentifiers.indices {
                let pointer = bufferPointer.baseAddress!.advanced(by: sourceIndex)
                let key = DifferenceDictionaryKey(pointer: pointer)

                switch sourceOccurrencesDictionary[key] {
                case nil:
                    sourceOccurrencesDictionary[key] = .unique(index: sourceIndex)

                case let .unique(otherIndex):
                    sourceOccurrencesDictionary[key] = .duplicate(
                        reference: DifferenceIndicesReference([otherIndex, sourceIndex])
                    )

                case let .duplicate(reference):
                    reference.push(sourceIndex)
                }
            }

            for targetIndex in targetSections.indices {
                var identifier = targetSections[targetIndex].differenceIdentifier
                let key = DifferenceDictionaryKey(pointer: &identifier)

                switch sourceOccurrencesDictionary[key] {
                case nil:
                    break

                case let .unique(sourceIndex):
                    if case .none = sourceTraces[sourceIndex].reference {
                        targetReferences[targetIndex] = sourceIndex
                        sourceTraces[sourceIndex].reference = targetIndex
                    }

                case let .duplicate(reference):
                    if let sourceIndex = reference.next() {
                        targetReferences[targetIndex] = sourceIndex
                        sourceTraces[sourceIndex].reference = targetIndex
                    }
                }
            }
        }

        var offsetByDelete = 0
        var untrackedSourceIndex: Int? = 0

        for sourceIndex in sourceSections.indices {
            sourceTraces[sourceIndex].deleteOffset = offsetByDelete

            if sourceTraces[sourceIndex].reference == nil {
                deleted.append(sourceIndex)

                sourceTraces[sourceIndex].isTracked = true
                offsetByDelete += 1
            }
        }

        for targetIndex in targetSections.indices {
            untrackedSourceIndex = untrackedSourceIndex.flatMap { index in
                sourceTraces.suffix(from: index).firstIndex { !$0.isTracked }
            }

            if let sourceIndex = targetReferences[targetIndex] {
                sourceTraces[sourceIndex].isTracked = true

                let sourceElement = sourceSections[sourceIndex]
                let targetElement = targetSections[targetIndex]

                if !targetElement.isContentEqual(to: sourceElement) {
                    updated.append(targetIndex)
                }

                if sourceIndex != untrackedSourceIndex {
                    let motion = DifferenceMotion(
                        source: sourceIndex - sourceTraces[sourceIndex].deleteOffset,
                        target: targetIndex
                    )

                    moved.append(motion)
                }
            } else {
                inserted.append(targetIndex)
            }
        }

        return SectionDifferenceChangeset(
            deleted: deleted,
            inserted: inserted,
            updated: updated,
            moved: moved,
            sourceTraces: sourceTraces,
            targetReferences: targetReferences
        )
    }
}
