import UIKit
import SnapKit

class LogOutButtonCell: UITableViewCell {
    
    struct Model {
        let icon: UIImage
        let title: String
    }
    
    private weak var iconView: UIImageView!
    private weak var title: UILabel!
    
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

extension LogOutButtonCell {
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        setupIcon()
        setupTitle()
    }
    
    private func setupIcon() {
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFit
        
        contentView.addSubview(iconView)
        
        iconView.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        self.iconView = iconView
    }
     
    private func setupTitle() {
        let nameLbl = UILabel()
        nameLbl.textColor = .logOut
        nameLbl.font = .button
        
        contentView.addSubview(nameLbl)
        
        nameLbl.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(12)
            make.centerY.equalToSuperview()
        }
        self.title = nameLbl
    }
}
