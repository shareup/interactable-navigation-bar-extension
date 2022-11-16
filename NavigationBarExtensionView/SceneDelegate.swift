import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo _: UISceneSession,
        options _: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }

        UINavigationBar.setUpAppearance()

        window = UIWindow(windowScene: scene)

        let initialViewController = ViewController()
        let rootViewController =
            UINavigationController(rootViewController: initialViewController)
        rootViewController.navigationBar.prefersLargeTitles = true
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
}
