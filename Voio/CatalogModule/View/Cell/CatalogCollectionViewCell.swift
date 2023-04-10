//
//  CatalogCollectionViewCell.swift
//  Voio
//
//  Created by Vladimir Lukyanenko on 07.04.2023.
//

import UIKit
import SDWebImage

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
    
    func setupCell(movie: Movie) {
        titleLabel.text = movie.trackName
        genreLabel.text = movie.primaryGenreName
        yearsLabel.text = String(movie.releaseDate.prefix(4))
        
        if let imageUrl = URL(string: movie.artworkUrlHighQuality) {
            ImageView.sd_imageIndicator = SDWebImageActivityIndicator.medium
            ImageView.sd_setImage(with: imageUrl, completed: nil)
        }
    }
    
    
    
}
