//
//  FavoriteViewController.swift
//  Voio
//
//  Created by Vladimir Lukyanenko on 08.04.2023.
//

import UIKit
import RealmSwift
import Lottie

class FavoriteViewController: UIViewController, FavoriteView {
    
    var tableView = UITableView()
    
    private let emptyCartView: LottieAnimationView = {
        let view = LottieAnimationView(name: "favorites")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emptyTitleLabel = UILabel(text: "Your favorite movies will be here", font: UIFont(name: "Comfortaa-Bold", size: 18), alignment: .center)
    
    private lazy var stacMain: UIStackView = {
        let stac = UIStackView(arrangedSubviews: [emptyCartView, emptyTitleLabel])
        stac.axis = .vertical
        stac.spacing = 8
        stac.translatesAutoresizingMaskIntoConstraints = false
        return stac
    }()
    
    private lazy var realm: Realm = {
        return try! Realm()
    }()
    
    private var movies: Results<MovieObject>?
    
    private let interactor: FavoriteInteractor
    var presenter: FavoritePresenter!
    
    init(interactor: FavoriteInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movies = realm.objects(MovieObject.self)
        
        presenter = FavoritePresenterImplementation(view: self, interactor: interactor)
        presenter.viewDidLoad()
        
        configureView()
        configTable()
        setConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
        
    }
    
    func setLoadingIndicator(isLoading: Bool) {
        //TODO: setLoadingIndicator
    }
    
    func updateMovies(movies: Results<MovieObject>?) {
        self.movies = movies
        tableView.reloadData()
        updateEmptyCartViewVisibility()
    }
    
    func showError(error: Error) {
        print("Error: \(error.localizedDescription)")
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
            presenter.deleteMovie(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectMovie(at: indexPath)
    }
    
}

extension FavoriteViewController: DetailsViewControllerDelegate {
    func didUpdateFavorite(movie: Movie) {
        presenter.viewWillAppear()
    }
}
