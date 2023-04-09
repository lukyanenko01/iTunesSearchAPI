//
//  FavoriteViewController.swift
//  Voio
//
//  Created by Vladimir Lukyanenko on 08.04.2023.
//

import UIKit
import RealmSwift
import Lottie


class FavoriteViewController: UIViewController {
    
    var tableView = UITableView()
    
    private let emptyCartView: LottieAnimationView = {
        let view = LottieAnimationView(name: "favorites")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emptyTitleLabel = UILabel(text: "Your favorite movies will be here", font: UIFont(name: "Arial Bold", size: 18), alignment: .center)
    
    private lazy var stacMain: UIStackView = {
        let stac = UIStackView(arrangedSubviews: [emptyCartView, emptyTitleLabel])
        stac.axis = .vertical
        stac.spacing = 8
        stac.translatesAutoresizingMaskIntoConstraints = false
        return stac
    }()
    
    private let realm = try! Realm()
    
    private var movies: Results<MovieObject>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movies = realm.objects(MovieObject.self)
        
        configureView()
        configTable()
        setConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        updateEmptyCartViewVisibility()
    }
    
    private func lottieViewAnimation() {
        emptyCartView.loopMode = .loop
        emptyCartView.play()
    }
    
    private func updateEmptyCartViewVisibility() {
        if let movies = movies, !movies.isEmpty {
            
            tableView.isHidden = false
            stacMain.isHidden = true
        } else {
            tableView.isHidden = true
            lottieViewAnimation()
            stacMain.isHidden = false
        }
    }
    
    private func configureView() {
        view.backgroundColor = UIColor(named: "custumBlack")
        title = "Favorites"
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .red
    }
    
    private func configTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.id)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func fetchFavorites() {
        movies = realm.objects(MovieObject.self)
    }
    
    private func setConstraints() {
        view.addSubview(tableView)
        view.addSubview(stacMain)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            stacMain.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stacMain.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stacMain.widthAnchor.constraint(equalTo: view.widthAnchor),
            stacMain.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1.0 / 2.0),
            emptyTitleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.id, for: indexPath) as? FavoriteTableViewCell else { return UITableViewCell() }
        if let movie = movies?[indexPath.row] {
            cell.setup(movie: movie)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                let realm = try Realm()
                guard let movie = movies?[indexPath.row] else { return }
                
                try realm.write {
                    realm.delete(movie)
                }
                
                self.tableView.reloadData()
                updateEmptyCartViewVisibility()
                
            } catch {
                print("Error deleting movie from Realm: \(error.localizedDescription)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let movie = movies?[indexPath.row] else { return }
        
        let detailsViewController = DetailsViewController()
        detailsViewController.delegate = self
        detailsViewController.setupViewToFavoritesController(movie: movie)
        present(detailsViewController, animated: true)
    }
    
}

extension FavoriteViewController: DetailsViewControllerDelegate {
    func didUpdateFavorite(movie: Movie) {
        fetchFavorites()
        updateEmptyCartViewVisibility()
        tableView.reloadData()
    }
}
