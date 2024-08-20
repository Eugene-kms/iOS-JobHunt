import UIKit
import JHCore

class SaveChangeButtonCell: UITableViewCell {
    
    private weak var saveChangeButton: UIButton!
    
    var editProfileViewModel: EditProfileViewModel!
    
    weak var viewController: UIViewController?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    private func commonInit() {
        setupUI()
    }
}

extension SaveChangeButtonCell {
    
    private func setupUI() {
        setupSaveChangeButton()
    }
    
    private func setupSaveChangeButton() {
        let button = UIButton()
        button.backgroundColor = .accent
        button.titleLabel?.font = .button
        button.setTitle(EditProfileViewController.EditProfileStrings.saveChange.rawValue, for: .normal)
        button.layer.cornerRadius = 28
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapSaveChange), for: .touchUpInside)
        
        contentView.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide.snp.bottom).offset(-40)
        }
        
        self.saveChangeButton = button
    }
    
    @objc private func didTapSaveChange() {
        Task { [weak self] in
            do {
                try await self?.editProfileViewModel.save()
            } catch {
                self?.viewController?.showError(error.localizedDescription)
            }
        }
    }
}
