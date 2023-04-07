//
//  AuthService.swift
//  Voio
//
//  Created by Vladimir Lukyanenko on 07.04.2023.
//

import Foundation
import FirebaseAuth

final class AuthService {
    
    func createUser(email: String, password: String, confirmPassword: String, completion: @escaping (Result<Void, Error>) -> Void) {
           guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
               completion(.failure(NSError(domain: "User registration", code: 1000, userInfo: [NSLocalizedDescriptionKey: "Empty fields"])))
               return
           }
           
           if password == confirmPassword {
               Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                   if let error = error {
                       completion(.failure(error))
                   } else {
                       completion(.success(()))
                   }
               }
           } else {
               completion(.failure(NSError(domain: "User registration", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Passwords do not match"])))
           }
       }
}
