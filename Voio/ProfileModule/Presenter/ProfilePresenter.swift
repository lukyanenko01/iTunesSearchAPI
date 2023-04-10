//
//  ProfilePresenter.swift
//  Voio
//
//  Created by Vladimir Lukyanenko on 09.04.2023.
//

import UIKit

protocol ProfileView: AnyObject {
    func showProfileData(_ userProfile: UserProfile)
    func showError(_ error: Error)
    func showProfileImage(_ image: UIImage)
}

protocol ProfilePresenter {
    func loadProfileData()
    func saveProfileData(name: String, lastName: String, image: UIImage)
    func handleImageSelection(image: UIImage)
}
