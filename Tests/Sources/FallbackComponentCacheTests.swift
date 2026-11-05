#if canImport(UIKit)
import XCTest

@testable import Levitan

@MainActor
final class FallbackComponentCacheTests: XCTestCase {

    private var cache = FallbackComponentCache()

    override func setUp() async throws {
        try await super.setUp()

        cache.reset()
    }

    func testEmptyCacheReturnsNil() {
        let cacheSize = restore(
            for: HashableContent(id: 1),
            proposedWidth: 200.0,
            proposedHeight: 100.0
        )

        XCTAssertNil(cacheSize)
    }

    func testStoredSizeIsRestoredForSameProposal() {
        let content = HashableContent(id: 1)
        let size = CGSize(width: 150.0, height: 40.0)
        let proposedWidth = 200.0
        let proposedHeight = 100.0

        store(
            for: content,
            size: size,
            sizing: ComponentSizing(width: .hug, height: .hug),
            proposedWidth: proposedWidth,
            proposedHeight: proposedHeight
        )

        let cacheSize = restore(
            for: content,
            proposedWidth: proposedWidth,
            proposedHeight: proposedHeight
        )

        XCTAssertEqual(cacheSize, size)
    }

    func testSizeIsNotRestoredForDifferentContent() {
        let size = CGSize(width: 150.0, height: 40.0)
        let proposedWidth = 200.0
        let proposedHeight = 100.0

        store(
            for: HashableContent(id: 1),
            size: size,
            sizing: ComponentSizing(width: .hug, height: .hug),
            proposedWidth: proposedWidth,
            proposedHeight: proposedHeight
        )

        let otherCacheSize = restore(
            for: HashableContent(id: 2),
            proposedWidth: proposedWidth,
            proposedHeight: proposedHeight
        )

        XCTAssertNil(otherCacheSize)
    }

    func testEquatableOnlyContentIsCached() {
        let content = EquatableContent(id: 1)
        let size = CGSize(width: 150.0, height: 40.0)
        let proposedWidth = 200.0
        let proposedHeight = 100.0

        store(
            for: content,
            size: size,
            sizing: ComponentSizing(width: .hug, height: .hug),
            proposedWidth: proposedWidth,
            proposedHeight: proposedHeight
        )

        let cacheSize = restore(
            for: content,
            proposedWidth: proposedWidth,
            proposedHeight: proposedHeight
        )

        let otherCacheSize = restore(
            for: EquatableContent(id: 2),
            proposedWidth: proposedWidth,
            proposedHeight: proposedHeight
        )

        XCTAssertEqual(cacheSize, size)
        XCTAssertNil(otherCacheSize)
    }

    func testSeveralSizesAreStoredForSameContent() {
        let content = HashableContent(id: 1)

        let firstSize = CGSize(width: 100.0, height: 60.0)
        let firstProposedWidth = 100.0
        let firstProposedHeight = 100.0

        let secondSize = CGSize(width: 300.0, height: 20.0)
        let secondProposedWidth = 300.0
        let secondProposedHeight = 100.0

        store(
            for: content,
            size: firstSize,
            sizing: ComponentSizing(width: .hug, height: .hug),
            proposedWidth: firstProposedWidth,
            proposedHeight: firstProposedHeight
        )

        store(
            for: content,
            size: secondSize,
            sizing: ComponentSizing(width: .hug, height: .hug),
            proposedWidth: secondProposedWidth,
            proposedHeight: secondProposedHeight
        )

        let firstCacheSize = restore(
            for: content,
            proposedWidth: firstProposedWidth,
            proposedHeight: firstProposedHeight
        )

        let secondCacheSize = restore(
            for: content,
            proposedWidth: secondProposedWidth,
            proposedHeight: secondProposedHeight
        )

        XCTAssertEqual(firstCacheSize, firstSize)
        XCTAssertEqual(secondCacheSize, secondSize)
    }

    func testResetRemovesAllSizes() {
        let firstContent = HashableContent(id: 1)
        let secondContent = HashableContent(id: 2)

        let size = CGSize(width: 150.0, height: 40.0)
        let proposedWidth = 200.0
        let proposedHeight = 100.0

        store(
            for: firstContent,
            size: size,
            sizing: ComponentSizing(width: .hug, height: .hug),
            proposedWidth: proposedWidth,
            proposedHeight: proposedHeight
        )

        store(
            for: secondContent,
            size: size,
            sizing: ComponentSizing(width: .hug, height: .hug),
            proposedWidth: proposedWidth,
            proposedHeight: proposedHeight
        )

        cache.reset()

        let firstCacheSize = restore(
            for: firstContent,
            proposedWidth: proposedWidth,
            proposedHeight: proposedHeight
        )

        let secondCacheSize = restore(
            for: secondContent,
            proposedWidth: proposedWidth,
            proposedHeight: proposedHeight
        )

        XCTAssertNil(firstCacheSize)
        XCTAssertNil(secondCacheSize)
    }

    func testResetSizeRemovesOnlyGivenContent() {
        let firstContent = HashableContent(id: 1)
        let secondContent = HashableContent(id: 2)

        let size = CGSize(width: 150.0, height: 40.0)
        let proposedWidth = 200.0
        let proposedHeight = 100.0

        store(
            for: firstContent,
            size: size,
            sizing: ComponentSizing(width: .hug, height: .hug),
            proposedWidth: proposedWidth,
            proposedHeight: proposedHeight
        )

        store(
            for: secondContent,
            size: size,
            sizing: ComponentSizing(width: .hug, height: .hug),
            proposedWidth: proposedWidth,
            proposedHeight: proposedHeight
        )

        cache.resetSize(for: firstContent)

        let firstCacheSize = restore(
            for: firstContent,
            proposedWidth: proposedWidth,
            proposedHeight: proposedHeight
        )

        let secondCacheSize = restore(
            for: secondContent,
            proposedWidth: proposedWidth,
            proposedHeight: proposedHeight
        )

        XCTAssertNil(firstCacheSize)
        XCTAssertNotNil(secondCacheSize)
    }

    func testSmallerProposalThatFitsContentReusesSize() {
        let content = HashableContent(id: 1)
        let size = CGSize(width: 200.0, height: 20.0)

        store(
            for: content,
            size: size,
            sizing: ComponentSizing(width: .hug, height: .hug),
            proposedWidth: 375.0,
            proposedHeight: 100.0
        )

        let cacheSize = restore(
            for: content,
            proposedWidth: 250.0,
            proposedHeight: 50.0
        )

        XCTAssertEqual(cacheSize, size)
    }

    func testProposalSmallerThanContentIsNotReused() {
        let content = HashableContent(id: 1)

        store(
            for: content,
            size: CGSize(width: 200.0, height: 20.0),
            sizing: ComponentSizing(width: .hug, height: .hug),
            proposedWidth: 375.0,
            proposedHeight: 100.0
        )

        let firstCacheSize = restore(
            for: content,
            proposedWidth: 150.0,
            proposedHeight: 100.0
        )

        let secondCacheSize = restore(
            for: content,
            proposedWidth: 375.0,
            proposedHeight: 10.0
        )

        XCTAssertNil(firstCacheSize)
        XCTAssertNil(secondCacheSize)
    }

    func testProposalLargerThanStoredProposalIsNotReusedForFillingComponent() {
        let content = HashableContent(id: 1)

        store(
            for: content,
            size: CGSize(width: 375.0, height: 20.0),
            sizing: ComponentSizing(width: .fill, height: .fill),
            proposedWidth: 375.0,
            proposedHeight: 100.0
        )

        let cacheSize = restore(
            for: content,
            proposedWidth: 400.0,
            proposedHeight: 100.0
        )

        XCTAssertNil(cacheSize)
    }

    func testContentLargerThanProposalIsReusedUpToContentSize() {
        let content = HashableContent(id: 1)
        let size = CGSize(width: 100.0, height: 60.0)

        store(
            for: content,
            size: size,
            sizing: ComponentSizing(width: .hug, height: .hug),
            proposedWidth: 100.0,
            proposedHeight: 30.0
        )

        let cacheSize = restore(
            for: content,
            proposedWidth: 100.0,
            proposedHeight: 45.0
        )

        XCTAssertEqual(cacheSize, size)
    }

    func testFixedSizingUsesBoundingSizeAsTarget() {
        let content = HashableContent(id: 1)
        let size = CGSize(width: 50.0, height: 50.0)

        store(
            for: content,
            size: size,
            sizing: ComponentSizing(width: .fixed(50.0), height: .fixed(50.0)),
            proposedWidth: 300.0,
            proposedHeight: 300.0
        )

        let cacheSize = restore(
            for: content,
            proposedWidth: 100.0,
            proposedHeight: 100.0
        )

        XCTAssertEqual(cacheSize, size)
    }

    func testMixedSizingUsesBoundingSizeOnlyForFixedAxis() {
        let content = HashableContent(id: 1)
        let size = CGSize(width: 50.0, height: 20.0)

        store(
            for: content,
            size: size,
            sizing: ComponentSizing(width: .fixed(50), height: .hug),
            proposedWidth: nil,
            proposedHeight: nil
        )

        let cacheSize = restore(
            for: content,
            proposedWidth: 300.0,
            proposedHeight: nil
        )

        XCTAssertEqual(cacheSize, size)
    }

    func testUnboundedSizeIsReusedForUnboundedProposal() {
        let content = HashableContent(id: 1)
        let size = CGSize(width: 477.0, height: 20.0)

        store(
            for: content,
            size: size,
            sizing: ComponentSizing(width: .hug, height: .hug),
            proposedWidth: nil,
            proposedHeight: nil
        )

        let cacheSize = restore(
            for: content,
            proposedWidth: nil,
            proposedHeight: nil
        )

        XCTAssertEqual(cacheSize, size)
    }

    func testUnboundedSizeOfFillingComponentIsNotReusedForWiderProposal() {
        let content = HashableContent(id: 1)

        store(
            for: content,
            size: CGSize(width: 80.0, height: 20.0),
            sizing: ComponentSizing(width: .fill, height: .fill),
            proposedWidth: nil,
            proposedHeight: nil
        )

        let cacheSize = restore(
            for: content,
            proposedWidth: 375.0,
            proposedHeight: nil
        )

        XCTAssertNil(cacheSize)
    }

    func testUnboundedSizeIsNotReusedForNarrowerProposal() {
        let content = HashableContent(id: 1)

        store(
            for: content,
            size: CGSize(width: 477.0, height: 20.0),
            sizing: ComponentSizing(width: .hug, height: .hug),
            proposedWidth: nil,
            proposedHeight: nil
        )

        let cacheSize = restore(
            for: content,
            proposedWidth: 200.0,
            proposedHeight: nil
        )

        XCTAssertNil(cacheSize)
    }

    func testUnboundedHeightIsNotReusedForSmallerHeight() {
        let content = HashableContent(id: 1)

        store(
            for: content,
            size: CGSize(width: 375.0, height: 60.0),
            sizing: ComponentSizing(width: .hug, height: .hug),
            proposedWidth: 375.0,
            proposedHeight: nil
        )

        let cacheSize = restore(
            for: content,
            proposedWidth: 375.0,
            proposedHeight: 30.0
        )

        XCTAssertNil(cacheSize)
    }

    func testUnboundedSizeOfHuggingComponentIsNotReusedForWiderProposal() {
        let content = HashableContent(id: 1)

        store(
            for: content,
            size: CGSize(width: 50.0, height: 30.0),
            sizing: ComponentSizing(width: .hug, height: .hug),
            proposedWidth: nil,
            proposedHeight: nil
        )

        let cacheSize = restore(
            for: content,
            proposedWidth: 200.0,
            proposedHeight: nil
        )

        XCTAssertNil(cacheSize)
    }

    func testConcreteSizeIsNotReusedForUnboundedProposal() {
        let content = HashableContent(id: 1)

        store(
            for: content,
            size: CGSize(width: 200.0, height: 61.0),
            sizing: ComponentSizing(width: .hug, height: .hug),
            proposedWidth: 200.0,
            proposedHeight: nil
        )

        let cacheSize = restore(
            for: content,
            proposedWidth: nil,
            proposedHeight: nil
        )

        XCTAssertNil(cacheSize)
    }

    func testZeroSizeIsNotReusedForConcreteProposal() {
        let content = HashableContent(id: 1)

        store(
            for: content,
            size: CGSize(width: 477.0, height: 20.0),
            sizing: ComponentSizing(width: .hug, height: .hug),
            proposedWidth: .zero,
            proposedHeight: nil
        )

        let cacheSize = restore(
            for: content,
            proposedWidth: 200.0,
            proposedHeight: nil
        )

        XCTAssertNil(cacheSize)
    }

    func testInfiniteSizeIsNotReusedForConcreteProposal() {
        let content = HashableContent(id: 1)

        store(
            for: content,
            size: CGSize(width: 477.0, height: 20.0),
            sizing: ComponentSizing(width: .hug, height: .hug),
            proposedWidth: .infinity,
            proposedHeight: nil
        )

        let cacheSize = restore(
            for: content,
            proposedWidth: 600.0,
            proposedHeight: nil
        )

        XCTAssertNil(cacheSize)
    }

    func testZeroSizeIsReusedForUnboundedProposal() {
        let content = HashableContent(id: 1)
        let size = CGSize(width: 477.0, height: 20.0)

        store(
            for: content,
            size: size,
            sizing: ComponentSizing(width: .hug, height: .hug),
            proposedWidth: .zero,
            proposedHeight: nil
        )

        let cacheSize = restore(
            for: content,
            proposedWidth: nil,
            proposedHeight: nil
        )

        XCTAssertEqual(cacheSize, size)
    }

    func testInfiniteSizeIsNotReusedForUnboundedProposal() {
        let content = HashableContent(id: 1)

        store(
            for: content,
            size: CGSize(width: 477.0, height: 20.0),
            sizing: ComponentSizing(width: .hug, height: .hug),
            proposedWidth: .infinity,
            proposedHeight: nil
        )

        let cacheSize = restore(
            for: content,
            proposedWidth: nil,
            proposedHeight: nil
        )

        XCTAssertNil(cacheSize)
    }

    func testUnboundedSizeOfFixedComponentIsReusedForWiderProposal() {
        let content = HashableContent(id: 1)
        let size = CGSize(width: 477.0, height: 20.0)

        store(
            for: content,
            size: size,
            sizing: ComponentSizing(width: .fixed(477.0), height: .fixed(20.0)),
            proposedWidth: nil,
            proposedHeight: nil
        )

        let cacheSize = restore(
            for: content,
            proposedWidth: 600.0,
            proposedHeight: nil
        )

        XCTAssertEqual(cacheSize, size)
    }

    func testUnboundedSizeIsReusedForZeroProposal() {
        let content = HashableContent(id: 1)
        let size = CGSize(width: 477.0, height: 20.0)

        store(
            for: content,
            size: size,
            sizing: ComponentSizing(width: .hug, height: .hug),
            proposedWidth: nil,
            proposedHeight: nil
        )

        let cacheSize = restore(
            for: content,
            proposedWidth: .zero,
            proposedHeight: .zero
        )

        XCTAssertEqual(cacheSize, size)
    }

    func testUnboundedSizeOfFixedComponentIsReusedForInfiniteProposal() {
        let content = HashableContent(id: 1)
        let size = CGSize(width: 477.0, height: 20.0)

        store(
            for: content,
            size: size,
            sizing: ComponentSizing(width: .fixed(477.0), height: .fixed(20.0)),
            proposedWidth: nil,
            proposedHeight: nil
        )

        let cacheSize = restore(
            for: content,
            proposedWidth: .infinity,
            proposedHeight: .infinity
        )

        XCTAssertEqual(cacheSize, size)
    }

    func testConcreteWidthIsReusedWhenHeightIsUnboundedInBothProposals() {
        let content = HashableContent(id: 1)
        let size = CGSize(width: 200.0, height: 20.0)

        store(
            for: content,
            size: size,
            sizing: ComponentSizing(width: .hug, height: .hug),
            proposedWidth: 375.0,
            proposedHeight: nil
        )

        let cacheSize = restore(
            for: content,
            proposedWidth: 300.0,
            proposedHeight: nil
        )

        XCTAssertEqual(cacheSize, size)
    }

    func testUnboundedHeightIsNotReusedForLargerHeight() {
        let content = HashableContent(id: 1)

        store(
            for: content,
            size: CGSize(width: 375.0, height: 60.0),
            sizing: ComponentSizing(width: .fill, height: .fill),
            proposedWidth: 375.0,
            proposedHeight: nil
        )

        let cacheSize = restore(
            for: content,
            proposedWidth: 375.0,
            proposedHeight: 600.0
        )

        XCTAssertNil(cacheSize)
    }
}

extension FallbackComponentCacheTests {

    private struct HashableContent: Hashable {

        let id: Int
    }

    private struct EquatableContent: Equatable {

        let id: Int
    }

    private func store<Content: Equatable>(
        for content: Content,
        size: CGSize,
        sizing: ComponentSizing,
        proposedWidth: CGFloat?,
        proposedHeight: CGFloat?,
    ) {
        cache.storeSize(
            for: content,
            size: size,
            sizing: sizing,
            proposedWidth: proposedWidth,
            proposedHeight: proposedHeight
        )
    }

    private func restore<Content: Equatable>(
        for content: Content,
        proposedWidth: CGFloat?,
        proposedHeight: CGFloat?,
    ) -> CGSize? {
        cache.restoreSize(
            for: content,
            proposedWidth: proposedWidth,
            proposedHeight: proposedHeight
        )
    }
}
#endif
