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

    var artworkUrlHighQuality: String {
        return artworkUrl100.replacingOccurrences(of: "100x100", with: "164x172")
    }
}

