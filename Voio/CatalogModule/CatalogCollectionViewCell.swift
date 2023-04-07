//
//  CatalogCollectionViewCell.swift
//  Voio
//
//  Created by Vladimir Lukyanenko on 07.04.2023.
//

import UIKit

class CatalogCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var yearsLabel: UILabel!
    @IBOutlet weak var backgraundView: UIView!
    
    static let id = CatalogCollectionViewCell.description()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .none
        ImageView.layer.cornerRadius = 20
        ImageView.clipsToBounds = true
    }
    
    
    
}

struct SearchResult: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let trackName: String
    let primaryGenreName: String
    let artworkUrl100: String
    let releaseDate: String
    
    var artworkUrlHighQuality: String {
        return artworkUrl100.replacingOccurrences(of: "100x100", with: "164x172")
    }
}


