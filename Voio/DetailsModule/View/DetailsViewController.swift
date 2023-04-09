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
        scrollView.contentSize = contentSize
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private var contentSize: CGSize {
        CGSize(width: view.frame.width, height: view.frame.height+80)
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var titleLabel = UILabel(text: "", font: UIFont(name: "Comfortaa-Bold", size: 22), alignment: .left)
    
    private var genreLabel = UILabel(text: "", font: UIFont(name: "Comfortaa", size: 14), alignment: .left)
    
    private var yearsLabel = UILabel(text: "", font: UIFont(name: "Comfortaa", size: 14), alignment: .left)
    
    private var ratingLabel = UILabel(text: "", font: UIFont(name: "Comfortaa-Bold", size: 22), alignment: .left)
    
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
        button.titleLabel?.font = UIFont(name: "Comfortaa-Bold", size: 14)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        button.setTitle("Share", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Comfortaa-Bold", size: 14)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private lazy var stacHorizontal: UIStackView = {
        let stac = UIStackView(arrangedSubviews: [genreLabel, yearsLabel])
        stac.axis = .horizontal
        stac.distribution = .fillEqually
        return stac
    }()
    
    private lazy var stacVertical: UIStackView = {
        let stac = UIStackView(arrangedSubviews: [titleLabel, stacHorizontal, ratingLabel, descriptionTextView, addFavoriteButton, shareButton])
        stac.axis = .vertical
        stac.spacing = 10
        stac.translatesAutoresizingMaskIntoConstraints = false
        return stac
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, stacVertical])
        stackView.axis = .vertical
        stackView.spacing = 40
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var movie: Movie?
    
    weak var delegate: DetailsViewControllerDelegate?
    
    private var presenter: DetailsPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "custumBlack")
        setConstraints()
        addFavoriteButton.addTarget(self, action: #selector(addFavoriteButtonAction), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareButtonAction), for: .touchUpInside)
    }
    
    @objc func shareButtonAction() {
        guard let movie = movie else { return }
        let movieTitle = movie.trackName
        let movieGenre = movie.primaryGenreName
        let movieYear = String(movie.releaseDate.prefix(4))
        let movieRating = movie.contentAdvisoryRating ?? "No Rating"
        let movieDescription = movie.longDescription ?? "No description available."
        
        let movieInfo = """
            Check out this movie:
            Title: \(movieTitle)
            Genre: \(movieGenre)
            Year: \(movieYear)
            Rating: \(movieRating)
            Description: \(movieDescription)
        """
        
        let activityViewController = UIActivityViewController(activityItems: [movieInfo], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        present(activityViewController, animated: true, completion: nil)
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
        let font = UIFont(name: "Comfortaa", size: 14) ?? UIFont.systemFont(ofSize: 14)
        
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.font, value: font, range: NSRange(location: 0, length: attributedString.length))
        descriptionTextView.attributedText = attributedString
    }
    
    private func setConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -80),
            mainStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
    }
    
    @objc func addFavoriteButtonAction() {
        presenter.toggleFavoriteButton()
        if let movies = movie {
            delegate?.didUpdateFavorite(movie: movies)
        }
        dismiss(animated: true)
    }
    
}
