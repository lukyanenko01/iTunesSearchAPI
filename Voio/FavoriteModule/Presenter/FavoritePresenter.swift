//
//  FavoritePresenter.swift
//  Voio
//
//  Created by Vladimir Lukyanenko on 09.04.2023.
//

import Foundation
import RealmSwift

protocol FavoriteView: AnyObject {
    func setLoadingIndicator(isLoading: Bool)
    func updateMovies(movies: Results<MovieObject>?)
    func showError(error: Error)
}

protocol FavoritePresenter {
    func viewDidLoad()
    func viewWillAppear()
    func deleteMovie(at indexPath: IndexPath)
    func didSelectMovie(at indexPath: IndexPath)
}

protocol FavoriteInteractor {
    func fetchFavoriteMovies() -> Results<MovieObject>?
    func deleteFavoriteMovie(movie: MovieObject) throws
}
