#if canImport(UIKit)
import SwiftUI
import UIKit

internal final class ComponentHostingController<Content: View>: UIHostingController<Content> {

    // До iOS 16 UIHostingController самовольно отображает скрытую панель навигации.
    // Чтобы это предотвратить, переопределяем для него navigationController
    // и возвращаем nil для iOS старше 16.
    internal override var navigationController: UINavigationController? {
        if #available(iOS 16.0, tvOS 16.0, *) {
            return super.navigationController
        }

        return nil
    }

    internal override init(rootView: Content) {
        super.init(rootView: rootView)
    }

    @available(*, unavailable)
    internal required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Отключает все отступы SafeArea и клавиатуры для iOS до версии 16.4.
    ///
    /// Использует приватное API для отключения отступов, которое стало публичным в iOS 16.4.
    /// Для отключения отступов от клавиатуры используется рантайм Objective-C для подмены класса для `view`:
    /// - Если подменный класс уже зарегистрирован ранее в других экземплярах, то он устанавливается классом для `view`
    /// - Иначе создается сабкласс, наследующий класс `view`
    /// - В нем подменяется метод `keyboardWillShowWithNotification` на пустую реализацию
    /// - В последнем шаге этот сабкласс регистрируется и устанавливается классом для `view`
    private func disableSafeArea() {
        _disableSafeArea = true

        guard let viewClass = object_getClass(view) else {
            return
        }

        let viewSubclassName = String(cString: class_getName(viewClass)).appending("_IgnoringKeyboard")

        if let viewSubclass = NSClassFromString(viewSubclassName) {
            object_setClass(view, viewSubclass)
        } else {
            guard let viewClassNameUTF8 = (viewSubclassName as NSString).utf8String else {
                return
            }

            guard let viewSubclass = objc_allocateClassPair(viewClass, viewClassNameUTF8, 0) else {
                return
            }

            let willShowKeyboardSelector = NSSelectorFromString("keyboardWillShowWithNotification:")
            let originalWillShowKeyboardMethod = class_getInstanceMethod(viewClass, willShowKeyboardSelector)

            if let originalWillShowKeyboardMethod {
                let emptyWillShowKeyboardMethod: @convention(block) (AnyObject, AnyObject) -> Void = { _, _ in }

                class_addMethod(
                    viewSubclass,
                    willShowKeyboardSelector,
                    imp_implementationWithBlock(emptyWillShowKeyboardMethod),
                    method_getTypeEncoding(originalWillShowKeyboardMethod)
                )
            }

            objc_registerClassPair(viewSubclass)
            object_setClass(view, viewSubclass)
        }
    }

    internal override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 16.4, tvOS 16.4, *) {
            safeAreaRegions = []
        } else {
            disableSafeArea()
        }

        view.backgroundColor = .clear
    }
}
#endif
