//
//  FavoriteViewCell.swift
//  Voio
//
//  Created by Vladimir Lukyanenko on 08.04.2023.
//

import UIKit

class FavoriteViewCell: UIView {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var titleLabel = UILabel(text: "", font: UIFont(name: "Comfortaa-Bold", size: 18), alignment: .left)
    var genreLabel = UILabel(text: "", font: UIFont(name: "Comfortaa", size: 14), alignment: .left)
    var yearsLabel = UILabel(text: "", font: UIFont(name: "Comfortaa", size: 14), alignment: .left)
    
    private lazy var stacHorizontal: UIStackView = {
        let stac = UIStackView(arrangedSubviews: [genreLabel, yearsLabel])
        stac.axis = .horizontal
        stac.distribution = .equalCentering
        stac.translatesAutoresizingMaskIntoConstraints = false
        return stac
    }()
    
    private lazy var stacVertical: UIStackView = {
        let stac = UIStackView(arrangedSubviews: [titleLabel, stacHorizontal])
        stac.axis = .vertical
        stac.distribution = .fill
        stac.translatesAutoresizingMaskIntoConstraints = false
        return stac
    }()
    
    private lazy var mainStacHorizontal: UIStackView = {
        let stac = UIStackView(arrangedSubviews: [imageView, stacVertical])
        stac.axis = .horizontal
        stac.spacing = 15
        stac.translatesAutoresizingMaskIntoConstraints = false
        return stac
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
        setupViews()
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = UIColor(named: "customGrey")
        layer.cornerRadius = 6
        clipsToBounds = true
    }
    
    private func setConstraints() {
        addSubview(mainStacHorizontal)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            
            mainStacHorizontal.topAnchor.constraint(equalTo: topAnchor, constant: 18),
            mainStacHorizontal.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            mainStacHorizontal.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            mainStacHorizontal.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18),
        ])
    }
    
}
