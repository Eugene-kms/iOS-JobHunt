import UIKit
import JobHuntAccount

class TabBarController: UITabBarController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        tabBar.barTintColor = .white
        tabBar.tintColor = .accent
        
        tabBar.layer.masksToBounds = false
        tabBar.layer.shadowColor = UIColor.black.withAlphaComponent(0.6).cgColor
        tabBar.layer.shadowOpacity = 1
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 7)
    }
    
    private func setupViewControllers() {
        let home = UIViewController()
        home.tabBarItem = Tab.home.tabBarItem
        
        let jobs = UIViewController()
        jobs.tabBarItem = Tab.jobs.tabBarItem
        
        let messages = UIViewController()
        messages.tabBarItem = Tab.messages.tabBarItem
        
        let account = setupAccount()
        
        viewControllers = [
            home,
            jobs,
            messages,
            account
        ]
        
        selectedViewController = account
    }
    
    private func setupAccount() -> UIViewController {
        let viewModel = AccountViewModel()
        let account = AccountViewController()
        account.viewModel = viewModel
        
        let accountNavContr = UINavigationController(rootViewController: account)
        account.tabBarItem = Tab.account.tabBarItem
        account.title = Tab.account.tabBarItem.title
        
        return accountNavContr
    }
}
