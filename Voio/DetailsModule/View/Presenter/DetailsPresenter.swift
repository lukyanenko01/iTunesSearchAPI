//
//  DetailsPresenter.swift
//  Voio
//
//  Created by Vladimir Lukyanenko on 09.04.2023.
//

import Foundation

protocol DetailsView: AnyObject {
    func setupView(with movie: Movie)
    func updateFavoriteButton(movieInFavorites: Bool)
}

protocol DetailsPresenter {
    func viewDidLoad()
    func toggleFavoriteButton()
    func isMovieInFavorites(trackId: Int) -> Bool
}
