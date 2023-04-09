//
//  FavoritePresenterImplementation.swift
//  Voio
//
//  Created by Vladimir Lukyanenko on 09.04.2023.
//

import Foundation
import RealmSwift

class FavoriteInteractorImplementation: FavoriteInteractor {
    
    private let realm = try! Realm()
    
    func fetchFavoriteMovies() -> Results<MovieObject>? {
        return realm.objects(MovieObject.self)
    }
    
    func deleteFavoriteMovie(movie: MovieObject) throws {
        try realm.write {
            realm.delete(movie)
        }
    }
}


class FavoritePresenterImplementation: FavoritePresenter {
    
    weak var view: FavoriteView?
    var interactor: FavoriteInteractor
    
    init(view: FavoriteView, interactor: FavoriteInteractor) {
        self.view = view
        self.interactor = interactor
    }
    
    func viewDidLoad() {
        viewWillAppear()
    }
    
    func viewWillAppear() {
        let movies = interactor.fetchFavoriteMovies()
        view?.updateMovies(movies: movies)
    }
    
    
    func deleteMovie(at indexPath: IndexPath) {
        guard let movies = interactor.fetchFavoriteMovies() else { return }
        let movie = movies[indexPath.row]
        do {
            try interactor.deleteFavoriteMovie(movie: movie)
            viewWillAppear()
        } catch {
            view?.showError(error: error)
        }
    }
    
    func didSelectMovie(at indexPath: IndexPath) {
        guard let movies = interactor.fetchFavoriteMovies() else { return }
        let movie = movies[indexPath.row]
        
        let detailsViewController = DetailsViewController()
        detailsViewController.delegate = view as? DetailsViewControllerDelegate
        detailsViewController.setupViewToFavoritesController(movie: movie)
        
        if let view = view as? UIViewController {
            view.present(detailsViewController, animated: true)
        }
    }
    
}

