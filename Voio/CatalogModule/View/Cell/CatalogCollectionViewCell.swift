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
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.tintColor = .red
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .none
        ImageView.layer.cornerRadius = 20
        ImageView.clipsToBounds = true
        
        ImageView.addSubview(favoriteButton)
        ImageView.isUserInteractionEnabled = true
        setupFavoriteButtonConstraints()
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        
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
    
    private func setupFavoriteButtonConstraints() {
        NSLayoutConstraint.activate([
            favoriteButton.topAnchor.constraint(equalTo: ImageView.topAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: ImageView.trailingAnchor, constant: -8),
            favoriteButton.widthAnchor.constraint(equalToConstant: 24),
            favoriteButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    @objc private func favoriteButtonTapped() {
        if favoriteButton.currentImage == UIImage(systemName: "heart.fill") {
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    }
    
}
