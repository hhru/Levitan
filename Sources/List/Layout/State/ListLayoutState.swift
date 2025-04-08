#if canImport(UIKit)
import CoreGraphics
import Foundation

public struct ListLayoutState<Layout: ListLayout> {

    internal var frame: CGRect?

    public var origin: CGPoint?
    public var size: CGSize?

    public private(set) var sections: [ListLayoutSection<Layout>]

    internal init(sections: [ListLayoutSection<Layout>]) {
        self.sections = sections

        updateIndices()
    }

    internal func previousSectionItemPath(before sectionIndex: Int) -> ItemPath? {
        for previousSectionIndex in stride(from: sectionIndex - 1, through: .zero, by: -1) {
            let itemIndex = sections[previousSectionIndex].items.count - 1

            if itemIndex >= .zero {
                return ItemPath(
                    index: itemIndex,
                    section: previousSectionIndex
                )
            }
        }

        return nil
    }

    internal func previousItemPath(before itemPath: ItemPath) -> ItemPath? {
        guard itemPath.index > .zero else {
            return previousSectionItemPath(before: itemPath.section)
        }

        return ItemPath(
            index: itemPath.index - 1,
            section: itemPath.section
        )
    }

    internal mutating func reloadSection(at index: Int, with section: ListLayoutSection<Layout>) {
        sections[index] = section
    }

    internal mutating func deleteSection(at index: Int) {
        sections.remove(at: index)

        if index < sections.count {
            sections[index].origin = nil
        }
    }

    internal mutating func insertSection(at index: Int, with section: ListLayoutSection<Layout>) {
        if index < sections.count {
            sections[index].origin = nil
        }

        sections.insert(section, at: index)
    }

    internal mutating func reloadItem(at indexPath: IndexPath, with item: ListLayoutItem) {
        updateSection(at: indexPath.section) { section in
            section.reloadItem(at: indexPath.row, with: item)
        }
    }

    internal mutating func deleteItem(at indexPath: IndexPath) {
        updateSection(at: indexPath.section) { section in
            section.deleteItem(at: indexPath.row)
        }
    }

    internal mutating func insertItem(at indexPath: IndexPath, with item: ListLayoutItem) {
        updateSection(at: indexPath.section) { section in
            section.insertItem(at: indexPath.row, with: item)
        }
    }

    internal mutating func updateIndices() {
        sections.withUnsafeMutableBufferPointer { sections in
            for sectionIndex in sections.indices {
                sections[sectionIndex].updateIndices(index: sectionIndex)
            }
        }
    }

    internal mutating func updateFrames() {
        let origin = origin ?? .zero
        let size = size ?? .zero

        frame = CGRect(
            origin: origin,
            size: size
        )

        sections.withUnsafeMutableBufferPointer { sections in
            for sectionIndex in sections.indices {
                sections[sectionIndex].updateFrames(offset: origin)
            }
        }
    }
}

extension ListLayoutState {

    public func item(at indexPath: IndexPath) -> ListLayoutItem? {
        sections[safe: indexPath.section]?.items[safe: indexPath.item]
    }

    public func header(at index: Int) -> ListLayoutHeader? {
        sections[safe: index]?.header
    }

    public func footer(at index: Int) -> ListLayoutFooter? {
        sections[safe: index]?.footer
    }

    public func section(at index: Int) -> ListLayoutSection<Layout>? {
        sections[safe: index]
    }

    public mutating func updateSection(
        at index: Int,
        using body: (inout ListLayoutSection<Layout>) -> Void
    ) {
        sections.withUnsafeMutableBufferPointer { sections in
            body(&sections[index])
        }
    }
}
#endif
