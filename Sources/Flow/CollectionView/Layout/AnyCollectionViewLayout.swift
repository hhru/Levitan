#if canImport(UIKit)
import UIKit

internal protocol AnyCollectionViewLayout: UICollectionViewLayout {

    func itemContainerSize(at indexPath: IndexPath) -> CGSize
    func headerContainerSize(at indexPath: IndexPath) -> CGSize
    func footerContainerSize(at indexPath: IndexPath) -> CGSize
}
#endif
