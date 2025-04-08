#if canImport(UIKit)
import Foundation

public typealias ListSectionPredicate<Layout: ListLayout> = (_ section: ListSection<Layout>) -> Bool
#endif
