//
//  SingUpViewController.swift
//  Voio
//
//  Created by Vladimir Lukyanenko on 07.04.2023.
//

import UIKit
import FirebaseAuth

class SingUpViewController: UIViewController {
    
    private let viewBacgraund: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.8101552328)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var titleLabel = UILabel(text: "Sign up", font: UIFont(name: "Comfortaa-Bold", size: 22), alignment: .center)
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        return textField
    }()
    
    private let curentPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(string: "repeat password",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        return textField
    }()
    
    
    private let buttonEnter: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Сonfirm", for: .normal)
        button.titleLabel?.font = UIFont(name: "Comfortaa-Bold", size: 14)
        button.layer.cornerRadius = 10
        return button
    }()
    
    
    private lazy var stacVertical: UIStackView = {
        let stac = UIStackView(arrangedSubviews: [titleLabel, emailTextField, passwordTextField, curentPasswordTextField, buttonEnter])
        stac.axis = .vertical
        stac.spacing = 15
        stac.translatesAutoresizingMaskIntoConstraints = false
        return stac
    }()
    
    var isLoginMode = false
    private var viewBacgraundHeightConstraint: NSLayoutConstraint?
    private let authService = AuthService()
    private let passwordValidator = PasswordValidator()
    private let minLength = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "custumBlack")
        setConstraint()
        buttonAction()
        
        if isLoginMode {
            configureForLogin()
        }
        
        let tapHideKeyboard = UITapGestureRecognizer(target: self, action: #selector(tapHideKeyboardAction))
        view.addGestureRecognizer(tapHideKeyboard)
    }
    
    func configureForLogin() {
        titleLabel.text = "Log In"
        curentPasswordTextField.removeFromSuperview()
        if let heightConstraint = viewBacgraundHeightConstraint {
            heightConstraint.isActive = false
            viewBacgraundHeightConstraint = viewBacgraund.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3)
            viewBacgraundHeightConstraint?.isActive = true
        }
        buttonEnter.removeTarget(self, action: #selector(enterAction), for: .touchUpInside)
        buttonEnter.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
    }
    
    
    private func buttonAction() {
        buttonEnter.addTarget(self, action: #selector(enterAction), for: .touchUpInside)
    }
    
    private func registerNewUser() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let confirmPassword = curentPasswordTextField.text
        else {
            //TODO: Показать ошибку, если одно из полей пустое
            //TODO: Написать проверку паролля
            return
        }
        
        authService.createUser(email: email, password: password, confirmPassword: confirmPassword) { result in
            switch result {
            case .success():
                //TODO: Успешная регистрация
                print("User created successfully")
                //TODO:  перейти на следующий экран
            case .failure(let error):
                print("Error creating user: \(error.localizedDescription)")
                //TODO: обработать ошибку и показать алерт
            }
        }
    }
    
    private func showCodeValid(varification: String) {
        
    }
    
    private func setConstraint() {
        view.addSubview(viewBacgraund)
        view.addSubview(stacVertical)
        
        NSLayoutConstraint.activate([
            viewBacgraund.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewBacgraund.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            viewBacgraund.widthAnchor.constraint(equalToConstant: view.bounds.width-50)
        ])
        
        viewBacgraundHeightConstraint = viewBacgraund.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/2.5)
        viewBacgraundHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            buttonEnter.heightAnchor.constraint(equalToConstant: 40),
            stacVertical.centerXAnchor.constraint(equalTo: viewBacgraund.centerXAnchor),
            stacVertical.centerYAnchor.constraint(equalTo: viewBacgraund.centerYAnchor),
            stacVertical.leadingAnchor.constraint(equalTo: viewBacgraund.leadingAnchor, constant: 20),
            stacVertical.trailingAnchor.constraint(equalTo: viewBacgraund.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func tapHideKeyboardAction(_ sender: UITapGestureRecognizer) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        curentPasswordTextField.resignFirstResponder()
    }
    
    @objc func enterAction() {
        registerNewUser()
    }
    
    @objc func loginAction() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty
        else {
            //TODO: Показать ошибку, если одно из полей пустое
            //TODO: Написать проверку паролля
            return
        }
        
        authService.signIn(email: email, password: password) { result in
            switch result {
            case .success():
                print("User signed in successfully")
                //TODO: перейти на следующий экран
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    scene.windows.first?.rootViewController = MainTabBarController()
                }
            case .failure(let error):
                print("Error signing in: \(error.localizedDescription)")
                //TODO: обработать ошибку и показать алерт
            }
        }
    }
}
//TODO: UITextFieldDelegate
