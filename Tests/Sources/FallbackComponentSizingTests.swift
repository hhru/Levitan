#if canImport(UIKit)
import SwiftUI
import UIKit
import XCTest

@testable import Levitan

@MainActor
final class FallbackComponentSizingTests: XCTestCase {

    func testRepeatedProposal() {
        assertAllComponents(
            proposals: [
                ProposedViewSize(width: 200.0, height: nil),
                ProposedViewSize(width: 200.0, height: nil)
            ]
        )
    }

    func testRepeatedUnboundedProposal() {
        assertAllComponents(
            proposals: [
                ProposedViewSize(width: nil, height: nil),
                ProposedViewSize(width: nil, height: nil)
            ]
        )
    }

    func testUnboundedThenNarrowWidth() {
        assertAllComponents(
            proposals: [
                ProposedViewSize(width: nil, height: nil),
                ProposedViewSize(width: 200.0, height: nil)
            ]
        )
    }

    func testUnboundedThenWideWidth() {
        assertAllComponents(
            proposals: [
                ProposedViewSize(width: nil, height: nil),
                ProposedViewSize(width: 600.0, height: nil)
            ]
        )
    }

    func testWideThenSlightlyNarrowerWidth() {
        assertAllComponents(
            proposals: [
                ProposedViewSize(width: 600.0, height: nil),
                ProposedViewSize(width: 500.0, height: nil)
            ]
        )
    }

    func testWideThenNarrowWidth() {
        assertAllComponents(
            proposals: [
                ProposedViewSize(width: 600.0, height: nil),
                ProposedViewSize(width: 300.0, height: nil)
            ]
        )
    }

    func testNarrowThenWideWidth() {
        assertAllComponents(
            proposals: [
                ProposedViewSize(width: 200.0, height: nil),
                ProposedViewSize(width: 600.0, height: nil)
            ]
        )
    }

    func testZeroThenConcreteWidth() {
        assertAllComponents(
            proposals: [
                ProposedViewSize(width: .zero, height: nil),
                ProposedViewSize(width: 200.0, height: nil)
            ]
        )
    }

    func testInfiniteThenConcreteWidth() {
        assertAllComponents(
            proposals: [
                ProposedViewSize(width: .infinity, height: nil),
                ProposedViewSize(width: 200.0, height: nil)
            ]
        )
    }

    func testUnboundedThenLimitedHeight() {
        assertAllComponents(
            proposals: [
                ProposedViewSize(width: 200.0, height: nil),
                ProposedViewSize(width: 200.0, height: 30.0)
            ]
        )
    }

    func testUnboundedThenTallHeight() {
        assertAllComponents(
            proposals: [
                ProposedViewSize(width: 375.0, height: nil),
                ProposedViewSize(width: 375.0, height: 600.0)
            ]
        )
    }

    func testTallThenShorterHeight() {
        assertAllComponents(
            proposals: [
                ProposedViewSize(width: 375.0, height: 600.0),
                ProposedViewSize(width: 375.0, height: 300.0)
            ]
        )
    }

    func testConcreteThenUnboundedHeight() {
        assertAllComponents(
            proposals: [
                ProposedViewSize(width: 375.0, height: 600.0),
                ProposedViewSize(width: 375.0, height: nil)
            ]
        )
    }

    func testConcreteThenUnboundedWidth() {
        assertAllComponents(
            proposals: [
                ProposedViewSize(width: 200.0, height: nil),
                ProposedViewSize(width: nil, height: nil)
            ]
        )
    }

    func testUnboundedThenZeroWidth() {
        assertAllComponents(
            proposals: [
                ProposedViewSize(width: nil, height: nil),
                ProposedViewSize(width: .zero, height: nil)
            ]
        )
    }

    func testZeroThenUnboundedWidth() {
        assertAllComponents(
            proposals: [
                ProposedViewSize(width: .zero, height: nil),
                ProposedViewSize(width: nil, height: nil)
            ]
        )
    }

    func testInfiniteThenUnboundedWidth() {
        assertAllComponents(
            proposals: [
                ProposedViewSize(width: .infinity, height: nil),
                ProposedViewSize(width: nil, height: nil)
            ]
        )
    }

    func testUnboundedThenZeroHeight() {
        assertAllComponents(
            proposals: [
                ProposedViewSize(width: 200.0, height: nil),
                ProposedViewSize(width: 200.0, height: .zero)
            ]
        )
    }
}

extension FallbackComponentSizingTests {

    private static let widthSizings: [ComponentSizingStrategy] = [.hug, .fill, .fixed(250)]
    private static let heightSizings: [ComponentSizingStrategy] = [.hug, .fill, .fixed(40)]

    private func assertAllComponents(
        proposals: [ProposedViewSize],
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        for width in Self.widthSizings {
            for height in Self.heightSizings {
                let sizing = ComponentSizing(width: width, height: height)

                assertComponentCachedSizes(
                    for: TestingLabel(sizing: sizing),
                    proposals: proposals,
                    file: file,
                    line: line
                )

                assertComponentCachedSizes(
                    for: TestingBox(sizing: sizing),
                    proposals: proposals,
                    file: file,
                    line: line
                )
            }
        }
    }

    private func assertComponentCachedSizes<Content: FallbackComponent>(
        for content: Content,
        proposals: [ProposedViewSize],
        file: StaticString,
        line: UInt
    ) {
        let cache = FallbackComponentCache()
        let context = ComponentContext.default

        for index in proposals.indices {
            let expectedSize = sizeThatFits(
                proposals[index],
                content: content,
                context: context.fallbackComponentCache(nil)
            )

            let size = sizeThatFits(
                proposals[index],
                content: content,
                context: context.fallbackComponentCache(cache)
            )

            XCTAssertEqual(
                size,
                expectedSize,
                "content: \(content), proposals: \(proposals), step: \(index)",
                file: file,
                line: line
            )
        }
    }

    private func sizeThatFits<Content: FallbackComponent>(
        _ proposal: ProposedViewSize,
        content: Content,
        context: ComponentContext
    ) -> CGSize {
        let contentView = Content.UIView()

        contentView.update(with: content, context: context)

        return FallbackComponentBody(content: content).sizeThatFits(
            proposedWidth: proposal.width,
            proposedHeight: proposal.height,
            context: context,
            view: contentView
        )
    }
}
#endif
