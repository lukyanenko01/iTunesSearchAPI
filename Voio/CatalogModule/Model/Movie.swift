//
//  Movie.swift
//  Voio
//
//  Created by Vladimir Lukyanenko on 07.04.2023.
//

import Foundation

struct SearchResult: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let trackName: String
    let primaryGenreName: String
    let artworkUrl100: String
    let releaseDate: String
    let contentAdvisoryRating: String?
    let longDescription: String?
    let trackId: Int
    
    var artworkUrlHighQuality: String {
        return artworkUrl100.replacingOccurrences(of: "100x100", with: "164x172")
    }
    
}

extension Movie {
    init(movieObject: MovieObject) {
        self.trackId = movieObject.trackId
        self.trackName = movieObject.trackName
        self.primaryGenreName = movieObject.primaryGenreName
        self.releaseDate = movieObject.releaseDate
        self.contentAdvisoryRating = movieObject.contentAdvisoryRating
        self.longDescription = movieObject.longDescription
        self.artworkUrl100 = movieObject.artworkUrlHighQuality.replacingOccurrences(of: "164x172", with: "100x100")
    }
}
