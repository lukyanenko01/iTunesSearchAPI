//
//  UserProfile.swift
//  Voio
//
//  Created by Vladimir Lukyanenko on 09.04.2023.
//

import Foundation

struct UserProfile {
    var name: String
    var lastName: String
    var profileImageURL: String
    
    init(name: String, lastName: String, profileImageURL: String) {
        self.name = name
        self.lastName = lastName
        self.profileImageURL = profileImageURL
    }
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.lastName = dictionary["lastName"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
    }
    
    var dictionary: [String: Any] {
        return [
            "name": name,
            "lastName": lastName,
            "profileImageURL": profileImageURL
        ]
    }
}
