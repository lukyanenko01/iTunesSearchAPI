//
//  PasswordValidator.swift
//  Voio
//
//  Created by Vladimir Lukyanenko on 09.04.2023.
//

import Foundation

struct PasswordValidator {
    
    enum PasswordRequirements: Hashable {
        case minLength(amount: Int)
        case hasNumber
        case hasLowercase
        case hasUppercase
    }
    
    func validate(with requirements: [PasswordRequirements], text: String) -> [PasswordRequirements: Bool] {
        
        var result: [PasswordRequirements: Bool] = [:]
      
        
        requirements.forEach { requirement in
            switch requirement {
            case .minLength(let amount):
                result[requirement] = text.count >= amount
            case .hasNumber:
                let range = text.rangeOfCharacter(from: .decimalDigits)
                result[requirement] = range != nil
            case .hasLowercase:
                let range = text.rangeOfCharacter(from: .lowercaseLetters)
                result[requirement] = range != nil
            case .hasUppercase:
                let range = text.rangeOfCharacter(from: .uppercaseLetters)
                result[requirement] = range != nil
            }
        }
        
        return result
    }
}
