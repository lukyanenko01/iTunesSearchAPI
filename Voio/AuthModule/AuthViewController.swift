//
//  AuthViewController.swift
//  Voio
//
//  Created by Vladimir Lukyanenko on 07.04.2023.
//

import UIKit

class AuthViewController: UIViewController {
    
    private let viewBacgraund: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.1568627451, blue: 0.2470588235, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var titleLabel = UILabel(text: "Movie time.", font: UIFont(name: "Arial Bold", size: 20), alignment: .center)
    
    private var descriptionLabel = UILabel(text: "Not with us yet? Register now!", font: UIFont(name: "Arial", size: 18), alignment: .center)
    
    private let logInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Log in", for: .normal)
        button.setTitleColor(UIColor(named: "custumBlack"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir Next Demi", size: 14)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Sign up", for: .normal)
        button.setTitleColor(UIColor(named: "custumBlack"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir Next Demi", size: 14)
        button.layer.cornerRadius = 10
        return button
    }()
    
    private lazy var stacVertical: UIStackView = {
        let stac = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, logInButton, signUpButton, logInButton])
        stac.axis = .vertical
        stac.spacing = 20
        stac.translatesAutoresizingMaskIntoConstraints = false
        return stac
    }()
    
    private let customNavigationControllerDelegate = CustomNavigationControllerDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundImage()
        setConstraint()
        setupConfig()
        
        logInButton.addTarget(self, action: #selector(logInButtonAction), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonAction), for: .touchUpInside)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        roundTopCorners(view: viewBacgraund, radius: 30)
    }
    
    private func setupBackgroundImage() {
        let backgroundImage = UIImage(named: "Auth")
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.image = backgroundImage
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(backgroundImageView, at: 0)
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupConfig() {
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.8862745098, green: 0.1568627451, blue: 0.2352941176, alpha: 1)
        navigationController?.delegate = customNavigationControllerDelegate
    }
    
    private func roundTopCorners(view: UIView, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        view.layer.mask = mask
    }
    
    private func setConstraint() {
        view.addSubview(viewBacgraund)
        view.addSubview(stacVertical)
        
        NSLayoutConstraint.activate([
            viewBacgraund.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewBacgraund.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewBacgraund.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            viewBacgraund.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3),
            
            logInButton.heightAnchor.constraint(equalToConstant: 40),
            signUpButton.heightAnchor.constraint(equalToConstant: 40),
            stacVertical.topAnchor.constraint(equalTo: viewBacgraund.topAnchor, constant: 15),
            stacVertical.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stacVertical.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    @objc func logInButtonAction() {
        let controller = SingUpViewController()
        controller.isLoginMode = true
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    @objc func signUpButtonAction() {
        let controller = SingUpViewController()
        controller.isLoginMode = false
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
}



