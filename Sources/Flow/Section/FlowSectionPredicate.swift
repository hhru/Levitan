#if canImport(UIKit)
import Foundation

public typealias FlowSectionPredicate<Layout: FlowLayout> = (_ section: FlowSection<Layout>) -> Bool
#endif
