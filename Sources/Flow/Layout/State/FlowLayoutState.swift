#if canImport(UIKit)
import CoreGraphics
import Foundation

public struct FlowLayoutState<Layout: FlowLayout> {

    internal var frame: CGRect?

    public var origin: CGPoint?
    public var size: CGSize?

    public private(set) var sections: [FlowLayoutSection<Layout>]

    public var isValid: Bool {
        origin != nil && size != nil
    }

    public func item(at indexPath: IndexPath) -> FlowLayoutItem? {
        sections[safe: indexPath.section]?.items[safe: indexPath.item]
    }

    public func header(at index: Int) -> FlowLayoutHeader? {
        sections[safe: index]?.header
    }

    public func footer(at index: Int) -> FlowLayoutFooter? {
        sections[safe: index]?.footer
    }

    public func section(at index: Int) -> FlowLayoutSection<Layout>? {
        sections[safe: index]
    }

    public mutating func updateSection(
        at index: Int,
        using body: (inout FlowLayoutSection<Layout>) -> Void
    ) {
        sections.withUnsafeMutableBufferPointer { sections in
            body(&sections[index])
        }
    }
}

extension FlowLayoutState {

    @MainActor
    internal init(sections: [FlowLayoutSection<Layout>]) {
        self.sections = sections

        updateIndices()
    }

    @MainActor
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

    @MainActor
    internal func previousItemPath(before itemPath: ItemPath) -> ItemPath? {
        guard itemPath.index > .zero else {
            return previousSectionItemPath(before: itemPath.section)
        }

        return ItemPath(
            index: itemPath.index - 1,
            section: itemPath.section
        )
    }

    @MainActor
    internal mutating func reloadSection(at index: Int, with section: FlowLayoutSection<Layout>) {
        sections[index] = section
    }

    @MainActor
    internal mutating func deleteSection(at index: Int) {
        sections.remove(at: index)

        if index < sections.count {
            sections[index].origin = nil
        }
    }

    @MainActor
    internal mutating func insertSection(at index: Int, with section: FlowLayoutSection<Layout>) {
        if index < sections.count {
            sections[index].origin = nil
        }

        sections.insert(section, at: index)
    }

    @MainActor
    internal mutating func reloadItem(at indexPath: IndexPath, with item: FlowLayoutItem) {
        updateSection(at: indexPath.section) { section in
            section.reloadItem(at: indexPath.row, with: item)
        }
    }

    @MainActor
    internal mutating func deleteItem(at indexPath: IndexPath) {
        updateSection(at: indexPath.section) { section in
            section.deleteItem(at: indexPath.row)
        }
    }

    @MainActor
    internal mutating func insertItem(at indexPath: IndexPath, with item: FlowLayoutItem) {
        updateSection(at: indexPath.section) { section in
            section.insertItem(at: indexPath.row, with: item)
        }
    }

    @MainActor
    internal mutating func updateIndices() {
        sections.withUnsafeMutableBufferPointer { sections in
            for sectionIndex in sections.indices {
                sections[sectionIndex].updateIndices(index: sectionIndex)
            }
        }
    }

    @MainActor
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
#endif
