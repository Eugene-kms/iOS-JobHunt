import UIKit
import DesignKit
import SnapKit

enum OTPStrings: String {
    case title = "Enter the OTP code"
    case subtitle = "To confirm the account, enter the 6-digit code we sent to "
    case bottomTitle = "Didn’t receive code?"
    case resendCode = "Resend code"
    case submitButton = "Submit"
}

public final class OTPViewController: UIViewController {
    
    private weak var stackView: UIStackView!
    private weak var resendButton: UIButton!
    private weak var submitButton: UIButton!
    
    private var textFields: [UITextField] = []
    var phoneNumber: String = ""
    
    public var viewModel: OTPViewModel!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        configureKeyboard()
        
        textFields.first?.becomeFirstResponder()
    }
    
    private func setupUI() {
        
        view.backgroundColor = .white
        
        setupStackView()
        setupTitle()
        stackView.addSpacing(height: 20)
        setupSubtitle()
        stackView.addSpacing(height: 20)
        setupOTPTextField()
        stackView.addSpacing(height: 16)
        setupBottomTitleWithResendButton()
        setupSubmitButton()
    }
    
    private func setupStackView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(64)
        }
        
        self.stackView = stackView
    }
    
    private func setupTitle() {
        let title = UILabel()
        
        let attributedString = NSAttributedString(
            string: OTPStrings.title.rawValue,
            attributes: [.paragraphStyle: UIFont.title.paragraphStyle(forLineHeight: 40)])
        
        title.attributedText = attributedString
        title.font = .title
        title.numberOfLines = 0
        title.textColor = .title
        
        stackView.addArrangedSubview(title)
    }
    
    private func setupSubtitle() {
        let subtitle = UILabel()
        
        let attributedString = NSMutableAttributedString(
            string: OTPStrings.subtitle.rawValue,
            attributes: [.foregroundColor: UIColor.subtitle, .font: .subtitle])
        
        let phoneNumberAttributedString = NSAttributedString(
            string: self.phoneNumber,
            attributes: [.foregroundColor: UIColor.accent, .font: .title])
        
        attributedString.append(phoneNumberAttributedString)
        subtitle.attributedText = attributedString
        
        subtitle.numberOfLines = 0
        
        stackView.addArrangedSubview(subtitle)
    }
    
    private func setupOTPTextField() {
        var fields = [UITextField]()
        
        let fieldsStackView = UIStackView()
        fieldsStackView.axis = .horizontal
        fieldsStackView.spacing = 9.4
        fieldsStackView.alignment = .center
        
        for index in 0...5 {
            let background = UIView()
            background.backgroundColor = .backgroundTextFieldOTP
            background.layer.cornerRadius = 12
            background.layer.masksToBounds = true
            
            let textField = UITextField()
            textField.textAlignment = .center
            textField.textColor = .textField
            textField.font = .otp
            textField.keyboardType = .numberPad
            textField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
            textField.tag = 100 + index
            
            background.addSubview(textField)
            
            background.snp.makeConstraints { make in
                make.height.equalTo(48)
                make.width.equalTo(48)
            }
            
            textField.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            fieldsStackView.addArrangedSubview(background)
            fields.append(textField)
        }
        
        stackView.addArrangedSubview(fieldsStackView)
        
        fieldsStackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
        for field in fields {
            field.superview?.layer.backgroundColor = UIColor.white.cgColor
            field.superview?.layer.borderColor = UIColor.accent.cgColor
            field.superview?.layer.shadowColor = UIColor.textField.cgColor
            field.superview?.layer.shadowOffset = CGSize(width: 0, height: 0)
            field.superview?.layer.shadowOpacity = 1
            field.superview?.layer.shadowRadius = 4
            field.superview?.layer.masksToBounds = false            
        }
        
        textFields = fields
    }
    
    private func setupBottomTitleWithResendButton() {
        let bottomView = UIStackView()
        bottomView.axis = .horizontal
        bottomView.alignment = .center
        bottomView.spacing = 50
        
        let bottomTitle = setupBottomTitle()
        let resendButton = setupResendButton()
        
        bottomView.addArrangedSubview(bottomTitle)
        bottomView.addArrangedSubview(resendButton)
        
        stackView.addSubview(bottomView)
        
        bottomView.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.centerX.equalToSuperview()
        }
        
        self.resendButton = resendButton
    }
    
    private func setupBottomTitle() -> UILabel {
        let bottomTitle = UILabel()
        bottomTitle.text = OTPStrings.bottomTitle.rawValue
        bottomTitle.font = .subtitle
        bottomTitle.numberOfLines = 1
        bottomTitle.textColor = .subtitle
        
        return bottomTitle
    }
    
    private func setupResendButton() -> UIButton {
        let resendButton = UIButton()
        resendButton.setTitleShadowColor(.accent, for: .normal)
        resendButton.titleLabel?.font = .button
        resendButton.setTitle(OTPStrings.resendCode.rawValue, for: .normal)
        
        return resendButton
    }
    
    private func setupSubmitButton() {
        let button = UIButton()
        button.backgroundColor = .accent
        button.titleLabel?.font = .button
        button.setTitle(OTPStrings.submitButton.rawValue, for: .normal)
        button.layer.cornerRadius = 28
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapSubmit), for: .touchUpInside)
        
        view.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
        self.submitButton = button
    }
}

extension OTPViewController {
    
    @objc func didChangeText(textField: UITextField) {
        let index = textField.tag - 100
        let nextIndex = index + 1
        
        guard nextIndex < textFields.count else {
            print("Successful authentication")
            submitButton.alpha = 1
            return
        }
        textFields[nextIndex].becomeFirstResponder()
    }
}
    
extension OTPViewController{
    
    private func setSubmitButtonDisabled() {
        submitButton.alpha = 0.5
        submitButton.isEnabled = false
    }
    
    private func setSubmitButtonEnabled() {
        submitButton.alpha = 1
        submitButton.isEnabled = true
    }
    
    @objc func didTapSubmit() {
        view.endEditing(true)
        self.setSubmitButtonDisabled()
        
        let digits = textFields.map { $0.text ?? "" }
        
        Task { [weak self] in
            do {
                try await self?.viewModel.verifyOTP(with: digits)
                
                let vc = UIViewController()
                vc.modalPresentationStyle = .fullScreen
                self?.navigationController?.setViewControllers([vc], animated: true)
            } catch {
                self?.showError(error.localizedDescription)
                self?.setSubmitButtonEnabled()
            }
        }
    }
}

extension OTPViewController {
    
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
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        
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
        
        submitButton.snp.updateConstraints { make in
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
        
        submitButton.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(topMargin)
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: animationCurve) {
            self.view.layoutIfNeeded()
        }
    }
}
