import UIKit
import DesignKit
import JHAccount
import SnapKit

enum OTPStrings: String {
    case title = "Enter the OTP code"
    case subtitle = "To confirm the account, enter the 6-digit code\n we sent to "
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
        setSubmitButtonDisabled()
    }
    
    private func setupStackView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
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
        title.numberOfLines = 1
        title.textColor = .title
        
        stackView.addArrangedSubview(title)
    }
    
    private func setupSubtitle() {
        let subtitle = UILabel()
        
        let attributedString = NSMutableAttributedString(
                    string: OTPStrings.subtitle.rawValue,
                    attributes: [
                        .foregroundColor: UIColor.subtitle,
                        .font: UIFont.subtitle
                    ])
       
        let phoneNumberAttributedString = NSAttributedString(
            string: self.phoneNumber,
            attributes: [
                .foregroundColor: UIColor.accent,
                .font: UIFont.button
            ])
        
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
            background.layer.masksToBounds = false
            
            let textField = UITextField()
            textField.textAlignment = .center
            textField.textColor = .textField
            textField.font = .otp
            textField.keyboardType = .numberPad
            textField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
            textField.tag = 100 + index
            textField.delegate = self
            
            background.addSubview(textField)
            
            background.snp.makeConstraints { make in
                make.size.equalTo(48)
            }
            
            textField.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            fieldsStackView.addArrangedSubview(background)
            fields.append(textField)
        }
        
        stackView.addArrangedSubview(fieldsStackView)
        
        fieldsStackView.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
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
        
        stackView.addArrangedSubview(bottomView)
        
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
        resendButton.setTitle(OTPStrings.resendCode.rawValue, for: .normal)
        resendButton.setTitleColor(.accent, for: .normal)
        resendButton.titleLabel?.font = .button

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
            print("Execute authentication")
            setSubmitButtonEnabled()
            return
        }
        textFields[nextIndex].becomeFirstResponder()
    }
}

extension OTPViewController: UITextFieldDelegate {
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        updateTextFieldAppearance(textField, isEditing: true)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        updateTextFieldAppearance(textField, isEditing: false)
    }
    
    private func updateTextFieldAppearance(_ textField: UITextField, isEditing: Bool) {
        
        if let background = textField.superview {
            if isEditing {
                background.layer.borderWidth = 2
                background.layer.borderColor = UIColor.accent.cgColor
                background.layer.backgroundColor = UIColor.white.cgColor
                
                background.layer.shadowColor = UIColor.backgroundTextFieldOTP.cgColor
                background.layer.shadowOffset = CGSize(width: 0, height: 2)
                background.layer.shadowOpacity = 1
                background.layer.shadowRadius = 4
                background.layer.masksToBounds = false
            } else {
                background.layer.backgroundColor = UIColor.backgroundTextFieldOTP.cgColor
                background.layer.borderColor = nil
                background.layer.borderWidth = 0
                background.layer.shadowColor = nil
                background.layer.shadowOffset = CGSize(width: 0, height: 0)
                background.layer.shadowOpacity = 0
                background.layer.shadowRadius = 0
            }
        }
    }
}

// MARK: Submit button

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
            } catch {
                self?.showError(error.localizedDescription)
                self?.setSubmitButtonEnabled()
            }
        }
    }
    
    private func didLoginSuccessfully() {
        NotificationCenter.default.post(.didLoginSuccessfully)
    }
}

//MARK: Configure Keyboard

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
