import Foundation

// TODO: Добавить документацию
@resultBuilder
public enum ViewArrayBuilder<Element> {

    public static func buildExpression(_ element: Element) -> [Element] {
        [element]
    }

    public static func buildExpression(_ elements: [Element]) -> [Element] {
        elements
    }

    public static func buildExpression(_ element: Element?) -> [Element] {
        element.map { [$0] } ?? []
    }

    public static func buildExpression(_ elements: [Element?]) -> [Element] {
        elements.compactMap { $0 }
    }

    public static func buildBlock(_ elements: [Element]...) -> [Element] {
        elements.flatMap { $0 }
    }

    public static func buildBlock(_ elements: [Element]) -> [Element] {
        elements
    }

    public static func buildOptional(_ elements: [Element]?) -> [Element] {
        elements ?? []
    }

    public static func buildEither(first elements: [Element]) -> [Element] {
        elements
    }

    public static func buildEither(second elements: [Element]) -> [Element] {
        elements
    }

    public static func buildArray(_ elements: [[Element]]) -> [Element] {
        elements.flatMap { $0 }
    }
}
