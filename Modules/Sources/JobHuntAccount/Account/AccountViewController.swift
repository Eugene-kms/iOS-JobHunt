import UIKit
import DesignKit
import SnapKit

public final class AccountViewController: UIViewController {
    
    enum Row: Int, CaseIterable {
        case profileData
        case notification
        case theme
        case helpCenter
        case rateOurApp
        case termOfService
        case logOut
    }
    
    private weak var tableView: UITableView!
    
    public var viewModel: AccountViewModel!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    private func configureTableView() {
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        
    }
}

extension AccountViewController {
    
    private func setupUI() {
        setupNavigationTitle()
        setupTableView()
    }
    
    private func setupNavigationTitle() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.font: UIFont.title]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    private func setupTableView() {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
        }
        
        self.tableView = tableView
    }
}

extension AccountViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Row.allCases.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: <#T##String#>)
    }
}

extension AccountViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let row = Row(rawValue: indexPath.row) else { return 0 }
        
        switch row {
        case.profileData:
            return 88
            
        case .notification, .theme, .helpCenter, .rateOurApp, .termOfService, .logOut:
            return 56
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let row = Row(rawValue: indexPath.row) else { return }
        
        switch row {
        case.profileData:
            presentEditProfile()
            
        case .logOut:
            didrequestLogOut()
        }
    }
    
    private func presentEditProfile() {
        let controller = EditProfileViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func didrequestLogOut() {
        let alert = UIAlertController(
            title: "Log Out!",
            message: "Do you really want to Log Out?",
            preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(
            title: "Confirm",
            style: .default,
            handler: {
                [weak self] _ in self?.didConfirmLogOut()
            })
        )
        alert.addAction(
            UIAlertAction(
                title: "Cancel",
                style: .cancel
            )
        )
        present(alert, animated: true)
    }
    
    private func didConfirmLogOut() {
        do {
            try viewModel.logOut()
        } catch {
            showError(error.localizedDescription)
        }
    }
}
