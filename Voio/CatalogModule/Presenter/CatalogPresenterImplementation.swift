//
//  CatalogPresenterImplementation.swift
//  Voio
//
//  Created by Vladimir Lukyanenko on 07.04.2023.
//

import Foundation

class CatalogPresenterImplementation: CatalogPresenter {
    
    weak var view: CatalogView?
    var interactor: CatalogInteractor
    
    init(view: CatalogView, interactor: CatalogInteractor) {
        self.view = view
        self.interactor = interactor
    }
    
    func viewDidLoad() {
        let genre = interactor.randomRecommendedGenre()
        searchMovies(query: genre)
    }
    
    func searchMovies(query: String) {
        view?.setLoadingIndicator(isLoading: true)
        
        interactor.searchMovies(query: query) { [weak self] (movies, error) in
            DispatchQueue.main.async {
                self?.view?.setLoadingIndicator(isLoading: false)
            }
            
            if let error = error {
                self?.view?.showError(error: error)
            } else if let movies = movies {
                self?.view?.updateMovies(movies: movies)
            }
        }
    }
}
