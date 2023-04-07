//
//  CatalogPresenter.swift
//  Voio
//
//  Created by Vladimir Lukyanenko on 07.04.2023.
//

import Foundation

import Foundation

protocol CatalogView: AnyObject {
    func setLoadingIndicator(isLoading: Bool)
    func updateMovies(movies: [Movie])
    func showError(error: Error)
}

protocol CatalogPresenter {
    func viewDidLoad()
    func searchMovies(query: String)
}

protocol CatalogInteractor {
    func searchMovies(query: String, completion: @escaping ([Movie]?, Error?) -> Void)
    func randomRecommendedGenre() -> String
}


