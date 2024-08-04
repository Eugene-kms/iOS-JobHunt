import UIKit
import SnapKit
import DesignKit
import SDWebImage

class AccountHeaderCell: UITableViewCell {
    
    private weak var containerView: UIView!
    private weak var stackView: UIStackView!
    private weak var accountImageView: UIImageView!
    private weak var companyLable: UILabel!
    private weak var locationLable: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    func configure(with header: Header) {
        accountImageView.sd_setImage(with: header.imageURL)
        companyLable.text = header.company
        locationLable.text = header.location
    }
    
    private func commonInit() {
        setupUI()
    }
}

extension AccountHeaderCell {
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        
    }
    
    private func setupContainer() {
        let view = UIView()
        view.backgroundColor = .backgroundTextField
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        
        contentView.addSubview(view)
        
        self.containerView = view
        
        view.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupStackView() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 12
        
        containerView.addSubview(stackView)
        
        self.stackView = stackView
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
    }
    
    private func setupImageView() {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .avatarAccount)
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        stackView.addArrangedSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(48)
        }
        
        self.accountImageView = imageView
    }
    
    private func setupLables() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        
        let companyLbl = setupCompanyLbl()
        stackView.addArrangedSubview(companyLbl)
        self.companyLable = companyLbl
        
        let locationLbl = setupLocationLbl()
        stackView.addArrangedSubview(locationLbl)
        self.locationLable = locationLbl
        
        self.stackView.addArrangedSubview(stackView)
    }
    
    private func setupCompanyLbl() -> UILabel {
        let companyLbl = UILabel()
        companyLbl.font = .titleAccountCell
        companyLbl.textColor = .textField
        return companyLbl
    }
    
    private func setupLocationLbl() -> UILabel {
        let locationLbl = UILabel()
        locationLbl.font = .subtitleAccountCell
        locationLbl.textColor = .subtitle
        return locationLbl
    }
    
    private func setupArrowRight() {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .arrowRight
        
        stackView.addArrangedSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
    }
}
