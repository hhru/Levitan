import Foundation

internal final class ItemDifferenceCalculator {

    // swiftlint:disable:next cyclomatic_complexity function_body_length
    internal func calculateDifference<Section: DiffableSection>(
        from sourceSections: [Section],
        to targetSections: [Section],
        sectionChangeset: SectionDifferenceChangeset,
        stageSections: DifferenceStageSections<Section>
    ) -> ItemDifferenceChangeset {
        let sourceSectionsItems = sourceSections.map { $0.items }
        let targetSectionsItems = targetSections.map { $0.items }

        stageSections.thirdStageSections.reserveCapacity(targetSectionsItems.count)
        stageSections.fourthStageSections.reserveCapacity(targetSectionsItems.count)

        var sourceItemTraces = sourceSectionsItems.map { section in
            ContiguousArray(repeating: DifferenceTrace<ItemPath>(), count: section.count)
        }

        var targetItemReferences = targetSectionsItems.map { section in
            ContiguousArray<ItemPath?>(repeating: nil, count: section.count)
        }

        let flattenSourceCount = sourceSectionsItems.reduce(into: 0) { $0 += $1.count }
        var flattenSourceIdentifiers = ContiguousArray<AnyHashable>()
        var flattenSourceItemPaths = ContiguousArray<ItemPath>()

        flattenSourceIdentifiers.reserveCapacity(flattenSourceCount)
        flattenSourceItemPaths.reserveCapacity(flattenSourceCount)

        var deleted: [ItemPath] = []
        var inserted: [ItemPath] = []
        var updated: [ItemPath] = []
        var moved: [DifferenceMotion<ItemPath>] = []

        for sourceSectionIndex in sourceSectionsItems.indices {
            for sourceItemIndex in sourceSectionsItems[sourceSectionIndex].indices {
                let sourceItemPath = ItemPath(
                    index: sourceItemIndex,
                    section: sourceSectionIndex
                )

                flattenSourceIdentifiers.append(sourceSectionsItems[sourceItemPath].differenceIdentifier)
                flattenSourceItemPaths.append(sourceItemPath)
            }
        }

        // swiftlint:disable:next closure_body_length
        flattenSourceIdentifiers.withUnsafeBufferPointer { bufferPointer in
            var sourceOccurrencesDictionary = [DifferenceDictionaryKey: DifferenceOccurrence](
                minimumCapacity: flattenSourceCount
            )

            for flattenSourceIndex in flattenSourceIdentifiers.indices {
                let pointer = bufferPointer.baseAddress!.advanced(by: flattenSourceIndex)
                let key = DifferenceDictionaryKey(pointer: pointer)

                switch sourceOccurrencesDictionary[key] {
                case nil:
                    sourceOccurrencesDictionary[key] = .unique(index: flattenSourceIndex)

                case let .unique(otherIndex):
                    sourceOccurrencesDictionary[key] = .duplicate(
                        reference: DifferenceIndicesReference([otherIndex, flattenSourceIndex])
                    )

                case let .duplicate(reference):
                    reference.push(flattenSourceIndex)
                }
            }

            for targetSectionIndex in targetSectionsItems.indices {
                let targetItems = targetSectionsItems[targetSectionIndex]

                for targetItemIndex in targetItems.indices {
                    var identifier = targetItems[targetItemIndex].differenceIdentifier
                    let key = DifferenceDictionaryKey(pointer: &identifier)

                    switch sourceOccurrencesDictionary[key] {
                    case nil:
                        break

                    case let .unique(flattenSourceIndex):
                        let sourceItemPath = flattenSourceItemPaths[flattenSourceIndex]

                        if sourceItemTraces[sourceItemPath].reference == nil {
                            let targetItemPath = ItemPath(
                                index: targetItemIndex,
                                section: targetSectionIndex
                            )

                            targetItemReferences[targetItemPath] = sourceItemPath
                            sourceItemTraces[sourceItemPath].reference = targetItemPath
                        }

                    case let .duplicate(reference):
                        if let flattenSourceIndex = reference.next() {
                            let sourceItemPath = flattenSourceItemPaths[flattenSourceIndex]

                            let targetItemPath = ItemPath(
                                index: targetItemIndex,
                                section: targetSectionIndex
                            )

                            targetItemReferences[targetItemPath] = sourceItemPath
                            sourceItemTraces[sourceItemPath].reference = targetItemPath
                        }
                    }
                }
            }
        }

        for sourceSectionIndex in sourceSectionsItems.indices {
            let sourceSection = sourceSections[sourceSectionIndex]
            let sourceItems = sourceSectionsItems[sourceSectionIndex]

            var firstStageItems = sourceItems

            if sectionChangeset.sourceTraces[sourceSectionIndex].reference != nil {
                var offsetByDelete = 0
                var secondStageItems = [Section.Item]()

                for sourceItemIndex in sourceItems.indices {
                    let sourceItemPath = ItemPath(
                        index: sourceItemIndex,
                        section: sourceSectionIndex
                    )

                    sourceItemTraces[sourceItemPath].deleteOffset = offsetByDelete

                    if let targetItemPath = sourceItemTraces[sourceItemPath].reference {
                        if sectionChangeset.targetReferences[targetItemPath.section] != nil {
                            let targetItem = targetSectionsItems[targetItemPath]
                            firstStageItems[sourceItemIndex] = targetItem

                            secondStageItems.append(targetItem)

                            continue
                        }
                    }

                    deleted.append(sourceItemPath)

                    sourceItemTraces[sourceItemPath].isTracked = true
                    offsetByDelete += 1
                }

                stageSections.secondStageSections.append(sourceSection.items(secondStageItems))
            }

            stageSections.firstStageSections[sourceSectionIndex] = sourceSection.items(firstStageItems)
        }

        for targetSectionIndex in targetSectionsItems.indices {
            guard let sourceSectionIndex = sectionChangeset.targetReferences[targetSectionIndex] else {
                stageSections.thirdStageSections.append(targetSections[targetSectionIndex])
                stageSections.fourthStageSections.append(targetSections[targetSectionIndex])

                continue
            }

            var untrackedSourceIndex: Int? = 0
            let targetItems = targetSectionsItems[targetSectionIndex]
            let sectionDeleteOffset = sectionChangeset.sourceTraces[sourceSectionIndex].deleteOffset
            let thirdStageSection = stageSections.secondStageSections[sourceSectionIndex - sectionDeleteOffset]

            stageSections.thirdStageSections.append(thirdStageSection)

            var fourthStageItems = [Section.Item]()

            fourthStageItems.reserveCapacity(targetItems.count)

            for targetItemIndex in targetItems.indices {
                untrackedSourceIndex = untrackedSourceIndex.flatMap { index in
                    sourceItemTraces[sourceSectionIndex].suffix(from: index).firstIndex { !$0.isTracked }
                }

                let targetItemPath = ItemPath(
                    index: targetItemIndex,
                    section: targetSectionIndex
                )

                let targetItem = targetSectionsItems[targetItemPath]

                guard
                    let sourceItemPath = targetItemReferences[targetItemPath],
                    let movedSourceSectionIndex = sectionChangeset.sourceTraces[sourceItemPath.section].reference
                else {
                    fourthStageItems.append(targetItem)
                    inserted.append(targetItemPath)

                    continue
                }

                sourceItemTraces[sourceItemPath].isTracked = true

                let sourceItem = sourceSectionsItems[sourceItemPath]

                fourthStageItems.append(targetItem)

                if !targetItem.isContentEqual(to: sourceItem) {
                    updated.append(sourceItemPath)
                }

                if sourceItemPath.section != sourceSectionIndex || sourceItemPath.index != untrackedSourceIndex {
                    let deleteOffset = sourceItemTraces[sourceItemPath].deleteOffset

                    let moveSourceItemPath = ItemPath(
                        index: sourceItemPath.index - deleteOffset,
                        section: movedSourceSectionIndex
                    )

                    let motion = DifferenceMotion(
                        source: moveSourceItemPath,
                        target: targetItemPath
                    )

                    moved.append(motion)
                }
            }

            stageSections.fourthStageSections.append(thirdStageSection.items(fourthStageItems))
        }

        return ItemDifferenceChangeset(
            deleted: deleted,
            inserted: inserted,
            updated: updated,
            moved: moved
        )
    }
}

extension MutableCollection where Element: MutableCollection, Index == Int, Element.Index == Int {

    internal subscript(path: ItemPath) -> Element.Element {
        get { self[path.section][path.index] }
        set { self[path.section][path.index] = newValue }
    }
}
