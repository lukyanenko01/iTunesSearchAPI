//
//  ProfileViewController.swift
//  Voio
//
//  Created by Vladimir Lukyanenko on 09.04.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SDWebImage

class ProfileViewController: UIViewController {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 12
        imageView.image = UIImage(systemName: "person.fill")
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.backgroundColor = UIColor(named: "custumBlack")
        textField.textColor = .white
        textField.attributedPlaceholder = NSAttributedString(string: "Name",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        return textField
    }()
    
    private let lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.backgroundColor = UIColor(named: "custumBlack")
        textField.textColor = .white
        textField.attributedPlaceholder = NSAttributedString(string: "Last name",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        return textField
    }()
    
    private lazy var stacVertical: UIStackView = {
        let stac = UIStackView(arrangedSubviews: [nameTextField, lastNameTextField])
        stac.axis = .vertical
        stac.distribution = .fillProportionally
        stac.spacing = 30
        stac.translatesAutoresizingMaskIntoConstraints = false
        return stac
    }()
    
    private lazy var mainStacHorizontal: UIStackView = {
        let stac = UIStackView(arrangedSubviews: [imageView, stacVertical])
        stac.axis = .horizontal
        stac.spacing = 15
        stac.translatesAutoresizingMaskIntoConstraints = false
        return stac
    }()
    
    private let buttonEnter: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Sign out", for: .normal)
        button.titleLabel?.font = UIFont(name: "Comfortaa-Bold", size: 14)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var bottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "custumBlack")
        title = "Profile"
        setConstraints()
        
        loadProfileDataFromFirestore()
        
        nameTextField.delegate = self
        lastNameTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveProfileDataToFirestore), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveProfileDataToFirestore), name: UIApplication.willTerminateNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        imageView.addGestureRecognizer(tapGesture)
        
        let tapHideKeyboard = UITapGestureRecognizer(target: self, action: #selector(tapHideKeyboardAction))
        view.addGestureRecognizer(tapHideKeyboard)
        
        buttonEnter.addTarget(self, action: #selector(exitAction), for: .touchUpInside)
        
    }
    
    func loadProfileDataFromFirestore() {
        FirestoreManager.shared.loadProfileData { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userProfile):
                    self?.nameTextField.text = userProfile.name
                    self?.lastNameTextField.text = userProfile.lastName
                    if let url = URL(string: userProfile.profileImageURL) {
                        self?.downloadProfileImageFromStorage(url: url)
                    }
                case .failure(let error):
                    print("Error getting user data from Firestore: \(error.localizedDescription)")
                }
            }
        }
    }
    
    
    
    @objc func saveProfileDataToFirestore() {
        guard let name = nameTextField.text, let lastName = lastNameTextField.text else { return }
        
        uploadProfileImageToStorage { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let imageURL):
                    let userProfile = UserProfile(name: name, lastName: lastName, profileImageURL: imageURL.absoluteString)
                    
                    FirestoreManager.shared.saveProfileData(userProfile) { error in
                        if let error = error {
                            print("Error saving user data to Firestore: \(error)")
                        } else {
                            print("User data successfully saved to Firestore")
                        }
                    }
                case .failure(let error):
                    print("Error uploading profile image to Firebase Storage: \(error)")
                }
            }
        }
    }
    
    
    func uploadProfileImageToStorage(completion: @escaping (Result<URL, Error>) -> Void) {
        guard let image = imageView.image else { return }
        
        FirebaseStorageManager.shared.uploadProfileImage(image) { result in
            completion(result)
        }
    }
    
    func downloadProfileImageFromStorage(url: URL) {
        let indicator = SDWebImageActivityIndicator.white
        imageView.sd_imageIndicator = indicator
        imageView.sd_setImage(with: url, placeholderImage: nil, options: .highPriority) { (image, error, _, _) in
            if let error = error {
                print("Error downloading profile image from Firebase Storage: \(error)")
            } else {
                self.imageView.image = image
            }
        }
    }
    
    private func setConstraints() {
        view.addSubview(mainStacHorizontal)
        view.addSubview(buttonEnter)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            
            mainStacHorizontal.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            mainStacHorizontal.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18),
            mainStacHorizontal.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -18),
            
            buttonEnter.heightAnchor.constraint(equalToConstant: 40),
            buttonEnter.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonEnter.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
        
        bottomConstraint = buttonEnter.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
        bottomConstraint?.isActive = true
    }
    
    @objc private func tapHideKeyboardAction(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
    }
    
    @objc private func handleTapGesture(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            present(imagePickerController, animated: true)
        }
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }
        
        let keyboardHeight = keyboardSize.height
        bottomConstraint?.constant = -keyboardHeight + 60
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        bottomConstraint?.constant = -40
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func exitAction() {
        
        do {
            try Auth.auth().signOut()
            let adminVC = AuthViewController()
            let navVc = UINavigationController(rootViewController: adminVC)
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                scene.windows.first?.rootViewController = navVc
            }
            
        } catch {
            
        }
    }
    
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        saveProfileDataToFirestore()
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else { return }
        imageView.image = image
        
        if let imageData = image.pngData() {
            let defaults = UserDefaults.standard
            defaults.set(imageData, forKey: "savedImage")
        }
        saveProfileDataToFirestore()
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}






