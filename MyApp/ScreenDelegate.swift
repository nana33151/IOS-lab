import UIKit

enum AppWindow {
    static func setRoot(_ viewController: UIViewController) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }

    static func logout() {
        AuthStorage.shared.clear()
        setRoot(UINavigationController(rootViewController: RegistrationViewController()))
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        let root: UIViewController = AuthStorage.shared.hasCredentials
            ? LoginViewController()
            : RegistrationViewController()
        window.rootViewController = UINavigationController(rootViewController: root)
        self.window = window
        window.makeKeyAndVisible()
    }
}
