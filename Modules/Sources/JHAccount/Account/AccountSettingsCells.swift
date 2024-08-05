import UIKit
import DesignKit
import SnapKit

class AccountSettingsCells: UITableViewCell {
    
    private weak var stackView: UIStackView!
    
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

extension AccountSettingsCells {
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        setupStackView()
//        setupNotification()
        setupSettingsCell(icon: .bell, nameLable: "Notification")
        setupSettingsCell(icon: .moon, nameLable: "Theme")
        setupSettingsCell(icon: .messageQuestion, nameLable: "Help Center")
        setupSettingsCell(icon: .star, nameLable: "Rate Our App")
        setupSettingsCell(icon: .notes, nameLable: "Term Of Service")
    }
    
    private func setupStackView() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 12
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.height.equalTo(56)
            make .centerX.equalToSuperview()
        }
        
        self.stackView = stackView
    }
    
//    private func setupNotification() {
//        let bell = UIImageView()
//        bell.image = UIImage(resource: .bell)
//        
//        stackView.addArrangedSubview(bell)
//        
//        bell.snp.makeConstraints { make in
//            make.size.equalTo(24)
//        }
//        
//        let nameLbl = UILabel()
//        nameLbl.text = "Notification"
//        nameLbl.textColor = .textField
//        nameLbl.font = .button
//        
//        stackView.addArrangedSubview(nameLbl)
//        
//        let arrow = UIImageView()
//        arrow.contentMode = .scaleAspectFit
//        arrow.image = .arrowRight
//        
//        stackView.addArrangedSubview(arrow)
//        
//        arrow.snp.makeConstraints { make in
//            make.size.equalTo(24)
//        }
//    }
    
    private func setupSettingsCell(icon: ImageResource, nameLable: String) {
        let bell = UIImageView()
        bell.image = UIImage(resource: icon)
        
        stackView.addArrangedSubview(bell)
        
        bell.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
        
        let nameLbl = UILabel()
        nameLbl.text = nameLable
        nameLbl.textColor = .textField
        nameLbl.font = .button
        
        stackView.addArrangedSubview(nameLbl)
        
        let arrow = UIImageView()
        arrow.contentMode = .scaleAspectFit
        arrow.image = .arrowRight
        
        stackView.addArrangedSubview(arrow)
        
        arrow.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
    }
}
