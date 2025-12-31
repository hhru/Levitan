#if canImport(UIKit)
import Foundation

public typealias FlowBuilder<Layout: FlowLayout> = ViewArrayBuilder<FlowSection<Layout>>
#endif
