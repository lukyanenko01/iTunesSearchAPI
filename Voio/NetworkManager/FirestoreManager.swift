//
//  FirestoreManager.swift
//  Voio
//
//  Created by Vladimir Lukyanenko on 09.04.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirestoreManager {
    
    static let shared = FirestoreManager()
    private init() {}
    
    private let db = Firestore.firestore()
    
    func loadProfileData(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(userID).getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists {
                let data = document.data()
                let userProfile = UserProfile(dictionary: data ?? [:])
                completion(.success(userProfile))
            } else {
//                completion(.failure(Error))
            }
        }
    }
    
    func saveProfileData(_ userProfile: UserProfile, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(userID).setData(userProfile.dictionary) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
