//
//  MovieService.swift
//  Voio
//
//  Created by Vladimir Lukyanenko on 07.04.2023.
//

import Foundation

class MovieService: CatalogInteractor {
    
    private let recommendedGenres = ["Action", "Comedy", "Adventure", "Horror", "Sci-Fi", "Drama", "Animation", "Thriller"]
    
    func searchMovies(query: String, completion: @escaping ([Movie]?, Error?) -> Void) {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://itunes.apple.com/search?term=\(encodedQuery)&media=movie&limit=8"
        
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(nil, error)
                } else if let data = data {
                    do {
                        let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                        completion(searchResult.results, nil)
                    } catch {
                        completion(nil, error)
                    }
                }
            }
            task.resume()
        }
    }
    
    func randomRecommendedGenre() -> String {
        return recommendedGenres[Int.random(in: 0..<recommendedGenres.count)]
    }
    
}
