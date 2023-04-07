//
//  MainTabBarController.swift
//  Voio
//
//  Created by Vladimir Lukyanenko on 07.04.2023.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTabBar()
        viewControllers = setViewControllers()
    }
    
    //TODO: изменить цвет UINavc
    
    private func configTabBar() {
        tabBar.tintColor = .white
        tabBar.isTranslucent = false
        tabBar.barTintColor = UIColor(named: "customGrey")
        tabBar.backgroundColor = UIColor(named: "customGrey")
    }
    
    private func setViewControllers() -> [UIViewController]{
//        let catalogNavVc = UINavigationController(rootViewController: CatalogViewController())
        
        let catalogViewController = CatalogViewController()
        let movieService = MovieService()
        let catalogPresenter = CatalogPresenterImplementation(view: catalogViewController, interactor: movieService)
        catalogViewController.presenter = catalogPresenter
        let catalogNavVc = UINavigationController(rootViewController: catalogViewController)

        let menuNavVc = UINavigationController(rootViewController: UIViewController())
        let cartNavVc = UINavigationController(rootViewController: UIViewController())
        
        let items = [
            configureNavigationBar(catalogNavVc, title: "Сatalog", image: UIImage(systemName: "music.note")),
            configureNavigationBar(menuNavVc, title: "Favorites", image: UIImage(systemName: "heart.fill")),
            configureNavigationBar(cartNavVc, title: "Profile", image: UIImage(systemName: "person.fill")),
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
}
