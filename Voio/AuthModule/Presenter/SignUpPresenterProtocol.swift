//
//  SignUpPresenterProtocol.swift
//  Voio
//
//  Created by Vladimir Lukyanenko on 10.04.2023.
//

import Foundation

protocol SignUpViewProtocol: AnyObject {
    func showError(message: String)
    func navigateToMainScreen()
}

protocol SignUpPresenterProtocol: AnyObject {
    func registerButtonTapped(withEmail email: String?, password: String?, confirmPassword: String?)
    func loginButtonTapped(withEmail email: String?, password: String?)
}
