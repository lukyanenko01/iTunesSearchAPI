//
//  DetailsPresenterImplementation.swift
//  Voio
//
//  Created by Vladimir Lukyanenko on 09.04.2023.
//

import Foundation

class DetailsPresenterImplementation: DetailsPresenter {
    private weak var view: DetailsView?
    private let movie: Movie
    private let movieService: DetailsMovieService
    
    init(view: DetailsView, movie: Movie, movieService: DetailsMovieService) {
        self.view = view
        self.movie = movie
        self.movieService = movieService
    }
    
    func viewDidLoad() {
        view?.setupView(with: movie)
        let movieInFavorites = movieService.isMovieInFavorites(trackId: movie.trackId)
        view?.updateFavoriteButton(movieInFavorites: movieInFavorites)
    }
    
    func toggleFavoriteButton() {
        let movieInFavorites = movieService.isMovieInFavorites(trackId: movie.trackId)
        
        if movieInFavorites {
            movieService.deleteMovieFromFavorites(trackId: movie.trackId)
        } else {
            movieService.saveMovieToFavorites(movie: movie)
        }
        
        view?.updateFavoriteButton(movieInFavorites: !movieInFavorites)
    }
    
    func isMovieInFavorites(trackId: Int) -> Bool {
        return movieService.isMovieInFavorites(trackId: trackId)
    }
}
