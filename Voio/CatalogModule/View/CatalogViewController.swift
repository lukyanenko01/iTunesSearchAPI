//
//  CatalogViewController.swift
//  Voio
//
//  Created by Vladimir Lukyanenko on 07.04.2023.
//

import UIKit
import SDWebImage

class CatalogViewController: UIViewController, CatalogView {
    
    var presenter: CatalogPresenter!
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private var movies: [Movie] = []
    
    private let movieService = MovieService()
        
    private let customNavigationControllerDelegate = CustomNavigationControllerDelegate()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "custumBlack")
        title = "Catalog"
        presenter.viewDidLoad()
        setupSearchController()
        configColletionView()
        setConstraints()
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.8862745098, green: 0.1568627451, blue: 0.2352941176, alpha: 1)
        navigationController?.delegate = customNavigationControllerDelegate
    }
    
    func setLoadingIndicator(isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
            collection.isHidden = true
        } else {
            activityIndicator.stopAnimating()
            collection.isHidden = false
        }
    }
    
    func updateMovies(movies: [Movie]) {
        self.movies = movies
        DispatchQueue.main.async {
            self.collection.reloadData()
        }
    }
    
    func showError(error: Error) {
        print("Error: \(error)")
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func configColletionView() {
        let nib = UINib(nibName: "CatalogCollectionViewCell", bundle: nil)
        collection.register(nib, forCellWithReuseIdentifier: CatalogCollectionViewCell.id)
        collection.backgroundColor = .none
        collection.showsVerticalScrollIndicator = false
        collection.dataSource = self
        collection.delegate = self
        collection.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setConstraints() {
        view.addSubview(collection)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            collection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            collection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
}

extension CatalogViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatalogCollectionViewCell.id, for: indexPath) as? CatalogCollectionViewCell else { return UICollectionViewCell() }
        
        cell.setupCell(movie: movies[indexPath.item])
        
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsViewController = DetailsViewController()
        detailsViewController.setupViewController(movie: movies[indexPath.item])
        present(detailsViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2.1
        let heigth = collectionView.frame.height / 3.2
        return CGSize(width: width, height: heigth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
}

extension CatalogViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            presenter.searchMovies(query: searchText)
        }
    }
}
