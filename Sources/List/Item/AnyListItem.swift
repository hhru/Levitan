import UIKit

public protocol AnyListItem {

    var identifier: AnyHashable { get }
    var sectionItem: ListSectionItem { get }
}
