import Foundation

internal protocol Diffable {

    var differenceID: AnyHashable { get }

    func isContentEqual(to other: Self) -> Bool
}
