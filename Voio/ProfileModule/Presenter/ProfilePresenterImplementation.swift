//
//  ProfilePresenterImplementation.swift
//  Voio
//
//  Created by Vladimir Lukyanenko on 09.04.2023.
//

import UIKit

class ProfilePresenterImplementation: ProfilePresenter {
    weak var view: ProfileView?
    private let firestoreManager: FirestoreManager
    private let firebaseStorageManager: FirebaseStorageManager
    
    init(view: ProfileView,
         firestoreManager: FirestoreManager = FirestoreManager.shared,
         firebaseStorageManager: FirebaseStorageManager = FirebaseStorageManager.shared) {
        self.view = view
        self.firestoreManager = firestoreManager
        self.firebaseStorageManager = firebaseStorageManager
    }
    
    func loadProfileData() {
        firestoreManager.loadProfileData { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userProfile):
                    self?.view?.showProfileData(userProfile)
                    if let url = URL(string: userProfile.profileImageURL) {
                        self?.firebaseStorageManager.downloadProfileImage(url: url) { result in
                            switch result {
                            case .success(let image):
                                self?.view?.showProfileImage(image)
                            case .failure(let error):
                                self?.view?.showError(error)
                            }
                        }
                    }
                case .failure(let error):
                    self?.view?.showError(error)
                }
            }
        }
    }
    
    func saveProfileData(name: String, lastName: String, image: UIImage) {
        firebaseStorageManager.uploadProfileImage(image) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let imageURL):
                    let userProfile = UserProfile(name: name, lastName: lastName, profileImageURL: imageURL.absoluteString)
                    self?.firestoreManager.saveProfileData(userProfile) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success:
                                self?.view?.showProfileData(userProfile)
                                self?.view?.showProfileImage(image)
                            case .failure(let error):
                                self?.view?.showError(error)
                            }
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.view?.showError(error)
                    }
                }
            }
        }
    }
    
    func handleImageSelection(image: UIImage) {
        view?.showProfileImage(image)
    }
    
}
