import UIKit
import DesignKit
import PhoneNumberKit
import SnapKit

enum PhoneNumberStrings: String {
    case title = "Log In"
    case subtitle = "Enter your phone number to continue"
    case continueButton = "Continue"
}

public class PhoneNumberViewController: UIViewController {
    
    private weak var stackView: UIStackView!
    private weak var textField: PhoneNumberTextField!
    private weak var continueButton: UIButton!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
//        textField.becomeFirstResponder()
    }
    
    private func setupUI() {
        
        view.backgroundColor = .white
        
        setupStackView()
        setupIcon()
        setupTitle()
        setupSubtitle()
    }
    
    private func setupStackView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
//        stackView.spacing = 24
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
        }
        
        self.stackView = stackView
    }
    
    private func setupIcon() {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFill
        icon.image = UIImage(resource: .logo)
        
        stackView.addArrangedSubview(icon)
        
        icon.snp.makeConstraints { make in
            make.size.equalTo(64)
        }
    }
    
    private func setupTitle() {
        let title = UILabel()
        
        let attributedString = NSAttributedString(
            string: PhoneNumberStrings.title.rawValue,
            attributes: [.paragraphStyle: UIFont.title.paragraphStyle(forLineHeight: 36)])
        
        title.attributedText = attributedString
        title.font = .title
        title.numberOfLines = 0
        title.textAlignment = .center
        title.textColor = .title
        
        stackView.addArrangedSubview(title)
        
        title.snp.makeConstraints { make in
            make..equalTo(24)
        }
    }
    
    private func setupSubtitle() {
        let subtitle = UILabel()
        
//        let attributedString = NSAttributedString(string: PhoneNumberStrings.subtitle.rawValue)
        
        subtitle.text = PhoneNumberStrings.subtitle.rawValue
        subtitle.font = .subtitle
        subtitle.numberOfLines = 0
        subtitle.textAlignment = .center
        subtitle.textColor = .subtitle
        
        stackView.addArrangedSubview(subtitle)
    }
}


