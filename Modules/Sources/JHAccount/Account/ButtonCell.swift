import UIKit

class ButtonCell: UITableViewCell {
    
    struct Model {
        let icon: UIImage
        let title: String
    }
    
    private weak var iconImageView: UIImageView!
    private weak var titleLable: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    func configure(with model: Model) {
        iconImageView.image = model.icon
        titleLable.text = model.title
    }
    
    private func commonInit() {
        setupUI()
    }
}

extension ButtonCell {
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        
    }
    
    private func setupIconImageView() {
        let icon = UIImageView()
        contentView.addSubview(icon)
        
        icon.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        self.iconImageView = icon
    }
    
    private func setupTitle() {
        let lable = UILabel()
        lable.textColor = .textField
        lable.font = .button
        
        contentView.addSubview(lable)
        
        lable.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(12)
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
        
        self.titleLable = lable
    }
}

extension ButtonCell.Model {
    static var logout: Self {
        Self(
            icon: UIImage(resource: .logOut),
            title: "Log Out")
    }
}
