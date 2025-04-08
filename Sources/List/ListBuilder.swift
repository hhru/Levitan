#if canImport(UIKit)
import Foundation

public typealias ListBuilder<Layout: ListLayout> = ViewArrayBuilder<ListSection<Layout>>
#endif
