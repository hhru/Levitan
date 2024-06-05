import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private func setupWindow(scene: UIScene) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }

        let window = UIWindow(windowScene: windowScene)

        self.window = window

        window.rootViewController = UINavigationController(rootViewController: HomeViewController())
        window.makeKeyAndVisible()
    }

    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBar.appearance()

        #if os(iOS)
        appearance.prefersLargeTitles = true
        #endif

        appearance.tintColor = Colors.important
    }

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        setupNavigationBarAppearance()
        setupWindow(scene: scene)
    }
}
