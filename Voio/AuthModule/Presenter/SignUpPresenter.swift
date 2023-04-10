//
//  SignUpPresenter.swift
//  Voio
//
//  Created by Vladimir Lukyanenko on 10.04.2023.
//

import Foundation

class SignUpPresenter: SignUpPresenterProtocol {
    weak var view: SignUpViewProtocol?
    private let authService: AuthManager
    private let passwordValidator: PasswordValidator
    private let minLength: Int
    
    init(view: SignUpViewProtocol, authService: AuthManager, passwordValidator: PasswordValidator, minLength: Int = 8) {
        self.view = view
        self.authService = authService
        self.passwordValidator = passwordValidator
        self.minLength = minLength
    }
    
    func registerButtonTapped(withEmail email: String?, password: String?, confirmPassword: String?) {
        if passwordValidatorCheck(text: password ?? "") {
            registerNewUser(email: email ?? "", password: password ?? "", confirmPassword: confirmPassword ?? "")
        } else {
            view?.showError(message: "The password must contain at least 8 characters, 1 number, 1 lowercase and 1 uppercase letter.")
        }
    }
    
    func loginButtonTapped(withEmail email: String?, password: String?) {
        loginAction(email: email ?? "", password: password ?? "")
    }
    
    private func registerNewUser(email: String, password: String, confirmPassword: String) {
        authService.createUser(email: email, password: password, confirmPassword: confirmPassword) { [weak self] result in
            switch result {
            case .success():
                self?.view?.navigateToMainScreen()
            case .failure(let error):
                self?.view?.showError(message: "\(error)")
            }
        }
    }
    
    private func loginAction(email: String, password: String) {
        authService.signIn(email: email, password: password) { [weak self] result in
            switch result {
            case .success():
                self?.view?.navigateToMainScreen()
            case .failure(_):
                self?.view?.showError(message: "You entered an incorrect password or email.")
            }
        }
    }
    
    private func passwordValidatorCheck(text: String) -> Bool {
        let validator = passwordValidator.validate(with: [.minLength(amount: minLength), .hasNumber, .hasLowercase, .hasUppercase], text: text)
        let validationResult = validator.values.allSatisfy { $0 }
        return validationResult
    }
}

