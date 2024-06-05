import Foundation

internal protocol Diffable {

    var differenceIdentifier: AnyHashable { get }

    func isContentEqual(to other: Self) -> Bool
}
