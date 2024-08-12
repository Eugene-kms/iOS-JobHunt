import UIKit
import SnapKit
import SDWebImage

class EditProfilePictureCell: UITableViewCell {
    
    private weak var title: UILabel!
    private weak var profileImageView: UIImageView!
    private weak var changeButton: UIButton!
    
    var didTap: (() -> ())?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    func configure(with image: UIImage) {
        profileImageView.image = image
    }
    
    func configure(with url: URL) {
        profileImageView.sd_setImage(with: url)
    }
    
    private func commonInit() {
        setupUI()
    }
}

extension EditProfilePictureCell {
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        setupProfileImageView()
    }
    
    private func setupTitle() {
        let title = UILabel()
        title.text = "Profile picture"
        title.textColor = .title
        title.font = .titleAccountCell
        
        contentView.addSubview(title)
        
        title.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(10)
        }
        self.title = title
    }
    
    private func setupChangeButton() {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .changeButton
        button.setTitleColor(.accent, for: .normal)
        button.setTitleColor(.accent, for: .highlighted)
        button.setTitleColor(.accent, for: .selected)
        button.setTitle(EditProfileViewController.EditProfileStrings.change.rawValue, for: .normal)
        button.addTarget(self, action: #selector(didTapChange), for: .touchUpInside)
        
        contentView.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.right.equalToSuperview()
        }
        
        self.changeButton = button
    }
    
    @objc private func didTapChange() {
        didTap?()
    }
    
    private func setupProfileImageView() {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 60
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(resource: .avatarAccount)
        
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(120)
            make.top.equalToSuperview().offset(12)
        }
        
        self.profileImageView = imageView
    }
}