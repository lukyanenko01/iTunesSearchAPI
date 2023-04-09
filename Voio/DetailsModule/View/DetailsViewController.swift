//
//  DetailsViewController.swift
//  Voio
//
//  Created by Vladimir Lukyanenko on 08.04.2023.
//

import UIKit
import SDWebImage
import RealmSwift

protocol DetailsViewControllerDelegate: AnyObject {
    func didUpdateFavorite(movie: Movie)
}

class DetailsViewController: UIViewController, DetailsView {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.frame = view.bounds
        scrollView.contentSize = contentSize
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private var contentSize: CGSize {
        CGSize(width: view.frame.width, height: view.frame.height+20)
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 3
        label.font = UIFont(name: "Arial Bold", size: 22)
        return label
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont(name: "Arial", size: 14)
        return label
    }()
    
    private let yearsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont(name: "Arial", size: 14)
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont(name: "Arial Bold", size: 22)
        return label
    }()
    
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        return textView
    }()
    
    private let addFavoriteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.8882787824, green: 0.158880502, blue: 0.2406231761, alpha: 1)
        button.setTitle("Add to Favorites", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir Next Demi Bold", size: 14)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var stacHorizontal: UIStackView = {
        let stac = UIStackView(arrangedSubviews: [genreLabel, yearsLabel])
        stac.axis = .horizontal
        stac.distribution = .fillEqually
        return stac
    }()
    
    private lazy var stacVertical: UIStackView = {
        let stac = UIStackView(arrangedSubviews: [titleLabel, stacHorizontal, ratingLabel, descriptionTextView, addFavoriteButton])
        stac.axis = .vertical
        stac.spacing = 10
        stac.translatesAutoresizingMaskIntoConstraints = false
        return stac
    }()
    
    private var movie: Movie?
    
    weak var delegate: DetailsViewControllerDelegate?
    
    private var presenter: DetailsPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "custumBlack")
        setConstraints()
        addFavoriteButton.addTarget(self, action: #selector(addFavoriteButtonAction), for: .touchUpInside)
    }
    
    func setupView(with movie: Movie) {
        titleLabel.text = movie.trackName
        genreLabel.text = movie.primaryGenreName
        yearsLabel.text = String(movie.releaseDate.prefix(4))
        ratingLabel.text = movie.contentAdvisoryRating
        setDescriptionTextField(text: movie.longDescription ?? "N/A")
        
        if let imageUrl = URL(string: movie.artworkUrlHighQuality) {
            imageView.sd_imageIndicator = SDWebImageActivityIndicator.medium
            imageView.sd_setImage(with: imageUrl, completed: nil)
        }
        
        updateFavoriteButton(movieInFavorites: presenter.isMovieInFavorites(trackId: movie.trackId))
    }
    
    func updateFavoriteButton(movieInFavorites: Bool) {
        if movieInFavorites {
            addFavoriteButton.backgroundColor = .white
            addFavoriteButton.setTitle("Delete", for: .normal)
            addFavoriteButton.setTitleColor(.black, for: .normal)
        } else {
            addFavoriteButton.backgroundColor = #colorLiteral(red: 0.8882787824, green: 0.158880502, blue: 0.2406231761, alpha: 1)
            addFavoriteButton.setTitle("Add to Favorites", for: .normal)
            addFavoriteButton.setTitleColor(.white, for: .normal)
        }
    }
    
    func setupViewController(movie: Movie) {
        self.movie = movie
        let movieService = DetailsMovieService()
        presenter = DetailsPresenterImplementation(view: self, movie: movie, movieService: movieService)
        presenter.viewDidLoad()
    }
    
    func setupViewToFavoritesController(movie: MovieObject) {
        self.movie = Movie(movieObject: movie)
        let movieService = DetailsMovieService()
        presenter = DetailsPresenterImplementation(view: self, movie: self.movie!, movieService: movieService)
        titleLabel.text = movie.trackName
        genreLabel.text = movie.primaryGenreName
        yearsLabel.text = String(movie.releaseDate.prefix(4))
        ratingLabel.text = movie.contentAdvisoryRating
        setDescriptionTextField(text: movie.longDescription)
        
        if let imageUrl = URL(string: movie.artworkUrlHighQuality) {
            imageView.sd_imageIndicator = SDWebImageActivityIndicator.medium
            imageView.sd_setImage(with: imageUrl, completed: nil)
        }
        
        updateFavoriteButton(movieInFavorites: presenter.isMovieInFavorites(trackId: movie.trackId))
    }
    
    private func setDescriptionTextField(text: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        let attributedString = NSMutableAttributedString(string: text)
        let font = UIFont(name: "Arial", size: 14) ?? UIFont.systemFont(ofSize: 14)
        
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.font, value: font, range: NSRange(location: 0, length: attributedString.length))
        descriptionTextView.attributedText = attributedString
    }
    
    private func setConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(stacVertical)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            imageView.widthAnchor.constraint(equalToConstant: view.bounds.width-40),
            imageView.heightAnchor.constraint(equalToConstant: view.bounds.height/3),
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            stacVertical.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40),
            stacVertical.widthAnchor.constraint(equalToConstant: view.bounds.width-40),
            stacVertical.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
        
        let widthConstraint = addFavoriteButton.widthAnchor.constraint(equalToConstant: view.bounds.width/2)
        widthConstraint.priority = UILayoutPriority(rawValue: 999)
        widthConstraint.isActive = true
    }
    
    @objc func addFavoriteButtonAction() {
        presenter.toggleFavoriteButton()
        if let movies = movie {
            delegate?.didUpdateFavorite(movie: movies)
        }
        dismiss(animated: true)
    }
    
}
