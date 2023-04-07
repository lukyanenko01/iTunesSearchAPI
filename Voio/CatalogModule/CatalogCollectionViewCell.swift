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
