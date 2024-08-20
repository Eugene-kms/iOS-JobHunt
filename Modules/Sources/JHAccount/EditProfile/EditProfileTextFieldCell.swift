import UIKit
import SnapKit

class EditProfileTextFieldCell: UITableViewCell {
    
    struct Model {
        let placeholder: String
        let header: String
        let text: String?
        
        init(placeholder: String, header: String, text: String? = nil) {
            self.placeholder = placeholder
            self.header = header
            self.text = text
        }
    }
    
    weak var textField: UITextField!
    
    private weak var containerView: UIView!
    private weak var headerLable: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    func configure(with model: Model) {
        textField.placeholder = model.placeholder
        textField.text = model.text
        headerLable.text = model.header
    }
    
    private func commonInit() {
        setupUI()
    }
}

extension EditProfileTextFieldCell {
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        setupHeader()
        setupContainer()
        setupTextField()
    }
    
    private func setupContainer() {
        let view = UIView()
        view.backgroundColor = .backgroundTextField
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        
        contentView.addSubview(view)
        
        view.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(56)
            make.top.equalTo(headerLable.snp.bottom).offset(12)
        }
        
        self.containerView = view
    }
    
    private func setupTextField() {
        let textField = UITextField()
        textField.textColor = .subtitle
        textField.font = .subtitle
        
        containerView.addSubview(textField)
        
        textField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
        
        self.textField = textField
    }
    
    private func setupHeader() {
        let lable = UILabel()
        lable.textColor = .title
        lable.font = .button
        
        contentView.addSubview(lable)
        
        lable.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
//            make.bottom.equalTo(containerView.snp.top).offset(-12)
        }
        
        self.headerLable = lable
    }
}

extension EditProfileTextFieldCell.Model {
    
    static func companyName(text: String? = nil) -> Self {
        Self(
            placeholder: EditProfileViewController.EditProfileStrings.companyNamePlaceholder.rawValue,
            header: EditProfileViewController.EditProfileStrings.companyName.rawValue,
            text: text)
    }
}
