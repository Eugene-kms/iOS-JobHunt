import UIKit
import JHCore
import SnapKit

public final class AccountViewController: UIViewController {
    
    enum Row: Int, CaseIterable {
        case profileData
        case spacer
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
        configureTableView()
        
        viewModel.didUpdateHeader = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        Task {
            await viewModel.fetchCompanyProfile()
        }
    }
    
    private func configureTableView() {
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AccountCompanyCell.self, forCellReuseIdentifier: AccountCompanyCell.identifier)
        tableView.register(AccountSettingCells.self, forCellReuseIdentifier: AccountSettingCells.identifier)
        tableView.register(LogOutButtonCell.self, forCellReuseIdentifier: LogOutButtonCell.identifier)
    }
}

extension AccountViewController {
    
    private func setupUI() {
        view.backgroundColor = .white
        
        setupNavigationTitle()
        setupTableView()
    }
    
    private func setupNavigationTitle() {
        let title = UILabel()
        title.text = "Account"
        title.font = .title
        title.textColor = .textField
        title.textAlignment = .left
        
        view.addSubview(title)
        
        title.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(57)
        }
    }

    private func setupTableView() {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
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
        guard 
            let row = Row(rawValue: indexPath.row) else { return UITableViewCell() }
        
        switch row {
        case .profileData:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountCompanyCell.identifier, for: indexPath) as? AccountCompanyCell else { return UITableViewCell() }
            cell.configure(with: viewModel.header)
            return cell
            
        case .spacer:
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            return cell
            
        case .notification:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountSettingCells.identifier, for: indexPath) as? AccountSettingCells else { return UITableViewCell() }
            cell.configure(with: .notification)
            return cell
            
        case .theme:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountSettingCells.identifier, for: indexPath) as? AccountSettingCells else { return UITableViewCell() }
            cell.configure(with: .theme)
            return cell
            
        case .helpCenter:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountSettingCells.identifier, for: indexPath) as? AccountSettingCells else { return UITableViewCell() }
            cell.configure(with: .helpCenter)
            return cell
            
        case .rateOurApp:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountSettingCells.identifier, for: indexPath) as? AccountSettingCells else { return UITableViewCell() }
            cell.configure(with: .rateOurApp)
            return cell
            
        case .termOfService:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountSettingCells.identifier, for: indexPath) as? AccountSettingCells else { return UITableViewCell() }
            cell.configure(with: .termOfService)
            return cell
            
        case .logOut:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LogOutButtonCell.identifier, for: indexPath) as? LogOutButtonCell else { return UITableViewCell() }
            cell.configure(with: .logOut)
            return cell
        }
    }
}

extension AccountViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard 
            let row = Row(rawValue: indexPath.row) else { return 0 }
        
        switch row {
        case.profileData:
            return 112
            
        case.spacer:
            return 20
            
        case .notification, .theme, .helpCenter, .rateOurApp, .termOfService, .logOut:
            return 56
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard 
            let row = Row(rawValue: indexPath.row) else { return }
        
        switch row {
        case .profileData:
            presentEditProfile()
            
        case .spacer:
            return
            
        case .notification, .theme, .helpCenter, .rateOurApp, .termOfService:
            return print("Empty ViewController!")
            
        case .logOut:
            didrequestLogOut()
        }
    }
    
    private func presentEditProfile() {
        let viewModel = EditProfileViewModel(container: viewModel.container)
        let controller = EditProfileViewController()
        controller.editProfileViewModel = viewModel
        
        controller.hidesBottomBarWhenPushed = true
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
