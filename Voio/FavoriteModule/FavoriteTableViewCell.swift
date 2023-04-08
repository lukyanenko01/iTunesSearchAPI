//
//  FavoriteTableViewCell.swift
//  Voio
//
//  Created by Vladimir Lukyanenko on 08.04.2023.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    static let id = FavoriteTableViewCell.description()
    
    let viewBacgraund = FavoriteViewCell()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 1.8
        layer.cornerRadius = 1.8
    }
    
    public func setup(movie: MovieObject) {
        viewBacgraund.titleLabel.text = movie.trackName
        viewBacgraund.genreLabel.text = movie.primaryGenreName
        viewBacgraund.yearsLabel.text = String(movie.releaseDate.prefix(4))
    }
    
    private func setConstraints() {
        contentView.addSubview(viewBacgraund)
        NSLayoutConstraint.activate([
            viewBacgraund.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            viewBacgraund.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            viewBacgraund.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            viewBacgraund.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}

