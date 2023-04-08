//
//  FavoriteViewCell.swift
//  Voio
//
//  Created by Vladimir Lukyanenko on 08.04.2023.
//

import UIKit

class FavoriteViewCell: UIView {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var titleLabel = UILabel(text: "", font: UIFont(name: "Arial", size: 18), alignment: .right)
    var genreLabel = UILabel(text: "", font: UIFont(name: "Arial", size: 14), alignment: .right)
    var yearsLabel = UILabel(text: "", font: UIFont(name: "Arial", size: 14), alignment: .center)
    
    private lazy var stacHorizontal: UIStackView = {
        let stac = UIStackView(arrangedSubviews: [genreLabel, yearsLabel])
        stac.axis = .horizontal
        stac.distribution = .equalCentering
        return stac
    }()
    
    private lazy var stacVertical: UIStackView = {
        let stac = UIStackView(arrangedSubviews: [titleLabel, stacHorizontal])
        stac.axis = .vertical
        stac.distribution = .fill
        stac.spacing = 5
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
        addSubview(imageView)
        addSubview(stacVertical)
        NSLayoutConstraint.activate([
            stacVertical.topAnchor.constraint(equalTo: topAnchor, constant: 18),
            stacVertical.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            stacVertical.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            stacVertical.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18),
        ])
    }
}
