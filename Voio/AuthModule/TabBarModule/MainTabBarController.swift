//
//  MainTabBarController.swift
//  Voio
//
//  Created by Vladimir Lukyanenko on 09.04.2023.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTabBar()
        viewControllers = setViewControllers()
        addSwipeGestureRecognizers()
    }
    
    //TODO: изменить цвет UINavc
    
    private func configTabBar() {
        tabBar.tintColor = .white
        tabBar.isTranslucent = false
        tabBar.barTintColor = UIColor(named: "customGrey")
        tabBar.backgroundColor = UIColor(named: "customGrey")
    }
    
    private func setViewControllers() -> [UIViewController]{
        
        let catalogViewController = CatalogViewController()
        let movieService = MovieService()
        let catalogPresenter = CatalogPresenterImplementation(view: catalogViewController, interactor: movieService)
        catalogViewController.presenter = catalogPresenter
        let catalogNavVc = UINavigationController(rootViewController: catalogViewController)
        
        
        let favoriteInteractor = FavoriteInteractorImplementation()
        let favoriteViewController = FavoriteViewController(interactor: favoriteInteractor)
        let favoriteNavVc = UINavigationController(rootViewController: favoriteViewController)
        
        let profileNavVc = UINavigationController(rootViewController: ProfileViewController())
        
        let items = [
            configureNavigationBar(catalogNavVc, title: "Сatalog", image: UIImage(systemName: "play.tv.fill")),
            configureNavigationBar(favoriteNavVc, title: "Favorites", image: UIImage(systemName: "heart.fill")),
            configureNavigationBar(profileNavVc, title: "Profile", image: UIImage(systemName: "person.fill")),
        ]
        
        return items
    }
    
    private func configureNavigationBar(_ rootVC: UIViewController, title: String, image: UIImage?) -> UIViewController {
        rootVC.tabBarItem.title = title
        if image != nil {
            rootVC.tabBarItem.image = image
        }
        return rootVC
    }
    
    private func addSwipeGestureRecognizers() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }
    
    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            if selectedIndex < viewControllers!.count - 1 {
                selectedIndex += 1
            }
        } else if gesture.direction == .right {
            if selectedIndex > 0 {
                selectedIndex -= 1
            }
        }
    }
    
}
