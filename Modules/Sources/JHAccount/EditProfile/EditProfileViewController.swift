import UIKit
import SnapKit

public final class EditProfileViewController: UIViewController {
    
    enum EditProfileStrings: String {
        case title = "Edit profile"
        case change = "Change"
        case saveChange = "Save Change"
        case companyName = "Company Name"
        case companyNamePlaceholder = "Your company display name"
    }
    
    enum Row: Int, CaseIterable {
        case profilePicture
        case companyName
        case saveChange
    }
    
    private weak var tableView: UITableView!
    private weak var saveChangeButton: UIButton!
    
    var editProfileViewModel: EditProfileViewModel!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureTableView()
        configureKeyboard()
        setupTapGesture()
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(EditProfilePictureCell.self, forCellReuseIdentifier: EditProfilePictureCell.identifier)
        tableView.register(EditProfileTextFieldCell.self, forCellReuseIdentifier: EditProfileTextFieldCell.identifier)
        tableView.register(SaveChangeButtonCell.self, forCellReuseIdentifier: SaveChangeButtonCell.identifier)
    }
}

// MARK: SetupUI

extension EditProfileViewController {
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never
        
        configureNavigationItem()
        setupTableView()
    }
    
    private func configureNavigationItem() {
        
        let customButton = UIButton(type: .system)
        customButton.setImage(UIImage(resource: .angleArrowLeft), for: .normal)
        customButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        customButton.addTarget(self, action: #selector(customButtonTapped), for: .touchUpInside)
        
        let barButtonItem = UIBarButtonItem(customView: customButton)
        
        navigationItem.leftBarButtonItem = barButtonItem
        navigationItem.title = "Edit profile"
    }
    
    @objc func customButtonTapped() {
        dismiss(animated: true)
    }
    
    private func setupTableView() {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(111)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(126)
        }
        
        self.tableView = tableView
        
    }
    
//    private func setupSaveChangeButton() {
//        let button = UIButton()
//        button.backgroundColor = .accent
//        button.titleLabel?.font = .button
//        button.setTitle(EditProfileStrings.saveChange.rawValue, for: .normal)
//        button.layer.cornerRadius = 28
//        button.layer.masksToBounds = true
//        button.addTarget(self, action: #selector(didTapSaveChange), for: .touchUpInside)
//        
//        view.addSubview(button)
//        
//        button.snp.makeConstraints { make in
//            make.height.equalTo(56)
//            make.left.equalTo(20)
//            make.right.equalTo(-20)
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
//        }
//        
//        self.saveChangeButton = button
//    }
//     
//    @objc private func didTapSaveChange() {
//        Task { [weak self] in
//            do {
//                try await self?.EditProfileViewModel.save()
//                self?.navigationController?.popViewController(animated: true)
//            } catch {
//                self?.showError(error.localizedDescription)
//            }
//        }
//    }
}

extension EditProfileViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Row.allCases.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = Row(rawValue: indexPath.row) else { return UITableViewCell() }
        
        switch row {
            
        case .profilePicture:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EditProfilePictureCell.identifier, for: indexPath) as? EditProfilePictureCell else { return UITableViewCell() }
            
            if let selectedImage = editProfileViewModel.selectedImage {
                cell.configure(with: selectedImage)
            } else if let url = editProfileViewModel.profilePictureURL {
                cell.configure(with: url)
            }
            
            cell.didTap = { [weak self] in
                self?.didTapProfilePicture()
            }
            
            return cell
            
        case .companyName:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EditProfileTextFieldCell.identifier, for: indexPath) as? EditProfileTextFieldCell else { return UITableViewCell() }
            
            cell.textField.delegate = self
            
            cell.configure(with: .companyName(text: editProfileViewModel.companyName))
            
            return cell
            
        case .saveChange:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SaveChangeButtonCell.identifier, for: indexPath) as? SaveChangeButtonCell else { return UITableViewCell() }
            
            cell.viewController = self
            
            return cell
        }
    }
}

extension EditProfileViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let row = Row(rawValue: indexPath.row) else { return 0 }
        
        switch row {
        case .profilePicture:
            return 156
            
        case .companyName:
            return 84
            
        case .saveChange:
            return 76
        }
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func didTapProfilePicture() {
        let alert = UIAlertController(
            title: "Select option",
            message: nil,
            preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(
            title: "Gallery",
            style: .default,
            handler: { [weak self] _ in
                self?.showImagePicker(with: .photoLibrary)
        }))
        
        alert.addAction(UIAlertAction(
            title: "Camera",
            style: .default,
            handler: { [weak self] _ in
                self?.showImagePicker(with: .camera)
        }))
        
        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel))
        
        self.present(alert, animated: true)
    }
    
    private func showImagePicker(with sourceType: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[.editedImage] as? UIImage {
            editProfileViewModel.selectedImage = selectedImage
            
            tableView.reloadRows(
                at: [IndexPath(row: Row.profilePicture.rawValue, section: 0)],
                with: .automatic)
        }
        picker.dismiss(animated: true)
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        guard
            let indexPath = tableView.indexPathForRow(at: textField.convert(textField.bounds.origin, to: tableView)),
            let row = Row(rawValue: indexPath.row)
        else { return }
        
        switch row {
        case .companyName:
            editProfileViewModel.companyName = textField.text ?? ""
        
        default:
            break
        }
    }
}

// MARK: Keyboard

extension EditProfileViewController {
    
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
        
        
        saveChangeButton.snp.updateConstraints { make in
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
        
        saveChangeButton.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(topMargin)
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: animationCurve) {
            self.view.layoutIfNeeded()
        }
    }
}
