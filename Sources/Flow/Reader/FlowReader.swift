#if canImport(UIKit)
import Foundation

public struct FlowReader<Layout: FlowLayout> {

    internal let viewContent: @Sendable (_ proxy: FlowReaderProxy<Layout>) -> Flow<Layout>
    internal let layoutContent: Flow<Layout>

    public init(content: @escaping @Sendable (_ proxy: FlowReaderProxy<Layout>) -> Flow<Layout>) {
        viewContent = content
        layoutContent = content(FlowReaderProxy { nil })
    }
}

extension FlowReader: FallbackComponent {

    public typealias UIView = FlowReaderView<Layout>
}

extension FlowReader: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.layoutContent == rhs.layoutContent
    }
}
#endif
