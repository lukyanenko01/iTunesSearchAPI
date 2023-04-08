//
//  MovieObject.swift
//  Voio
//
//  Created by Vladimir Lukyanenko on 08.04.2023.
//

import Foundation
import RealmSwift

class MovieObject: Object {
    @objc dynamic var trackName: String = ""
    @objc dynamic var primaryGenreName: String = ""
    @objc dynamic var releaseDate: String = ""
    @objc dynamic var contentAdvisoryRating: String = ""
    @objc dynamic var longDescription: String = ""
    @objc dynamic var artworkUrlHighQuality: String = ""
}
