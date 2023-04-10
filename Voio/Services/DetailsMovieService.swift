//
//  DetailsMovieService.swift
//  Voio
//
//  Created by Vladimir Lukyanenko on 09.04.2023.
//

import Foundation
import RealmSwift

class DetailsMovieService {
    
    func isMovieInFavorites(trackId: Int) -> Bool {
        do {
            let realm = try Realm()
            let movieObject = realm.objects(MovieObject.self).filter("trackId = %@", trackId).first
            return movieObject != nil
        } catch {
            //TODO: alert
            print("Error checking movie in Realm: \(error.localizedDescription)")
            return false
        }
    }
    
    func saveMovieToFavorites(movie: Movie) {
        let movieObject = MovieObject()
        movieObject.trackName = movie.trackName
        movieObject.primaryGenreName = movie.primaryGenreName
        movieObject.releaseDate = String(movie.releaseDate.prefix(4))
        movieObject.contentAdvisoryRating = movie.contentAdvisoryRating ?? "N/A"
        movieObject.longDescription = movie.longDescription ?? "N/A"
        movieObject.artworkUrlHighQuality = movie.artworkUrlHighQuality
        movieObject.trackId = movie.trackId
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(movieObject)
            }
        } catch {
            print("Error saving movie to Realm: \(error.localizedDescription)")
            //TODO: вызывать алерт
        }
    }
    
    func deleteMovieFromFavorites(trackId: Int) {
        do {
            let realm = try Realm()
            if let movieObject = realm.objects(MovieObject.self).filter("trackId = %@", trackId).first {
                try realm.write {
                    realm.delete(movieObject)
                }
            }
        } catch {
            print("Error deleting movie from Realm: \(error.localizedDescription)")
        }
    }
}
