import UIKit
import DesignKit
import SnapKit

class AccountSettingCells: UITableViewCell {
    
    struct Model {
        let icon: UIImage
        let title: String
    }
    
    private weak var iconView: UIImageView!
    private weak var title: UILabel!
    private weak var arrowView: UIImageView!
    private weak var containerView: UIView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    func configure(with model: Model) {
        iconView.image = model.icon
        title.text = model.title
    }
    
    private func commonInit() {
        setupUI()
    }
}

extension AccountSettingCells {
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        setupContainer()
        setupIcon()
        setupLable()
        setupArrow()
    }
    
    private func setupContainer() {
        let containerView = UIStackView()
        containerView.backgroundColor = .white
        containerView.spacing = 12
        
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
        }
        
        self.containerView = containerView
    }
    
    private func setupIcon() {
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFit
        
        containerView.addSubview(iconView)
        
        iconView.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        self.iconView = iconView
    }
        
    private func setupLable() {
        let nameLbl = UILabel()
        nameLbl.textColor = .textField
        nameLbl.font = .button
        
        containerView.addSubview(nameLbl)
        
        nameLbl.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(12)
            make.centerY.equalToSuperview()
        }
        self.title = nameLbl
    }
    
    private func setupArrow() {
        let arrow = UIImageView()
        arrow.contentMode = .scaleAspectFit
        arrow.image = .arrowRight
        
        containerView.addSubview(arrow)
        
        arrow.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        self.arrowView = arrow
    }
}
