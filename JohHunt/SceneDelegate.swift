import UIKit
import DesignKit
import JHAuthentication
import JHCore
import JHLogin
import Swinject

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var container: Container!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        setupContainer()
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        UINavigationController.styleJobHunt()

        let navigationController = UINavigationController(rootViewController: setupInitialViewController())

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        subscribeToLogin()
        subscribeToLogOut()
    }
     
    private func setupInitialViewController() -> UIViewController {
        let authService = AuthServiceLive()
        
        if authService.isAuthenticated {
            return setupTabBar()
        } else {
            return setupPhoneNumberController()
        }
    }
    
    private func setupTabBar() -> UIViewController {
        TabBarController(container: container)
    }
    
    private func setupPhoneNumberController() ->UIViewController {
        let viewModel = PhoneNumberViewModel(container: container)
        
        let phoneNumberController = PhoneNumberViewController()
        phoneNumberController.viewModel = viewModel
        return phoneNumberController
    }
}

//MARK: Login

extension SceneDelegate {
    
    private func subscribeToLogin() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didLoginSuccessfully),
            name: Notification.Name(AppNotification.didLoginSuccessfully.rawValue),
            object: nil)
    }
    
    @objc private func didLoginSuccessfully() {
        let navigationController = window?.rootViewController as? UINavigationController
        navigationController?.setViewControllers([setupTabBar()], animated: true)
    }
}

//MARK: Logout

extension SceneDelegate {
    
    private func subscribeToLogOut() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didLogOut),
            name: Notification.Name(AppNotification.didLogOut.rawValue),
            object: nil)
    }
    
    @objc private func didLogOut() {
        let navigationController = window?.rootViewController as? UINavigationController
        navigationController?.setViewControllers([setupPhoneNumberController()], animated: true)
    }
}

extension SceneDelegate {
    private func setupContainer() {
        container = Container()
        AppAssembly(container: container).asemble()
    }
}
