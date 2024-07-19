import UIKit
import SnapKit
import PhoneNumberKit
import DesignKit
import JHAuthentication

enum PhoneNumberStrings: String {
    case title = "Log In"
    case subtitle = "Enter your phone number to\n continue"
    case continueButton = "Continue"
}

public final class PhoneNumberViewModel {
    let authService: AuthService
        
    public init(authService: AuthService) {
        self.authService = authService
    }
    
    public func requestOTP(with phoneNumber: String) async throws {
        try await authService.requestOTP(forPhoneNumber: phoneNumber)
    }
}

public final class PhoneNumberViewController: UIViewController {
    
    private weak var stackView: UIStackView!
    private weak var textField: PhoneNumberTextField!
    private weak var continueButton: UIButton!
    
    public var viewModel: PhoneNumberViewModel!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        configureKeyboard()
        subscribeToTextChange()
        textFieldDidChange()
        
        textField.becomeFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func subscribeToTextChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange), name: UITextField.textDidChangeNotification, object: self)
    }
    
    private func setupUI() {
        
        view.backgroundColor = .white
        
        setupStackView()
        setupIcon()
        stackView.addSpacing(height: 24)
        setupTitle()
        stackView.addSpacing(height: 8)
        setupSubtitle()
        stackView.addSpacing(height: 20)
        setupTextField()
        setupContinueButton()
    }
    
    private func setupStackView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
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
    
    private func setupTextField() {
        let background = UIView()
        background.layer.cornerRadius = 16
        background.layer.masksToBounds = true
        background.backgroundColor = .backgroundTextField
        
        stackView.addArrangedSubview(background)
        
        background.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        let textField = PhoneNumberTextField(insets: UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20), clearButtonPadding: 0)
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.font = .textField
        textField.textColor = .textField
        textField.withExamplePlaceholder = true
        textField.attributedPlaceholder = NSAttributedString(string: "Enter phone number")
        
        background.addSubview(textField)
        
        textField.snp.makeConstraints { make in
            make.right.equalTo(0)
            make.left.equalTo(0)
            make.centerY.equalToSuperview()
        }
        
        self.textField = textField
    }
    
    private func setupContinueButton() {
        let button = UIButton()
        button.backgroundColor = .accent
        button.titleLabel?.font = .button
        button.setTitle(PhoneNumberStrings.continueButton.rawValue, for: .normal)
        button.layer.cornerRadius = 28
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
        
        view.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
        }
        
        self.continueButton = button
    }
}

extension PhoneNumberViewController {
    
    @objc func textFieldDidChange() {
        continueButton.isEnabled = textField.isValidNumber
        continueButton.alpha = textField.isValidNumber ? 1.0 : 0.25
    }
    
    @objc func didTapContinue() {
        guard textField.isValidNumber, let phoneNumber = textField.text else { return }
        
        Task { [weak self] in
            do {
                try await self?.viewModel.requestOTP(with: phoneNumber)
                self?.presentOTP()
            } catch {
                self?.showError(error.localizedDescription)
            }
        }
    }
    
    private func presentOTP() {
        let viewController = OTPViewController()
        viewController.viewModel = OTPViewModel(authService: viewModel.authService)
        viewController.phoneNumber = textField.text ?? ""
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension UIViewController {
    func showError(_ error: String) {
        let alert = UIAlertController(
            title: "Error",
            message: error,
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(
            title: "Ok",
            style: .default))
        
        self.present(alert, animated: true)
    }
}

extension PhoneNumberViewController {
    
    private func configureKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        
        setupTapGesture()
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        let animationCurveRawNumber = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNumber?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        let topMargin = -endFrame.height + view.safeAreaInsets.bottom - 16
        
        
        continueButton.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(topMargin)
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: animationCurve) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        let animationCurveRawNumber = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNumber?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        let topMargin: CGFloat = -40
        
        continueButton.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(topMargin)
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: animationCurve) {
            self.view.layoutIfNeeded()
        }
    }
}

