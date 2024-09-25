//
//  ViewController.swift
//  APPIOApp
//
//  Created by Ваня Сокол on 20.09.2024.
//

import UIKit

final class WelcomeViewController: UIViewController {
    
    private let coreData = CoreDataService.shared
    private let startGameButton = UIButton()
    private let continueGameButton = UIButton()
    private var startGameButtonTopConstraint: NSLayoutConstraint?
    var hasSavedGame = false {
        didSet {
            updateUIForSavedGame()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        setupLayout()
        setupUI()
        updateUIForSavedGame()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUIForSavedGame()
    }

    private func setupUI() {
        startGameButton.setTitle("Начать новую игру", for: .normal)
        startGameButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        startGameButton.setTitleColor(.black, for: .normal)
        startGameButton.backgroundColor = .white
        startGameButton.layer.cornerRadius = 16
        
        continueGameButton.setTitle("Продолжить текущую игру", for: .normal)
        continueGameButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        continueGameButton.setTitleColor(.black, for: .normal)
        continueGameButton.backgroundColor = .white
        continueGameButton.layer.cornerRadius = 16
        
        startGameButton.isHidden = true
        continueGameButton.isHidden = true
    }
    
    private func setupLayout() {
        view.addSubview(continueGameButton)
        view.addSubview(startGameButton)
        
        continueGameButton.translatesAutoresizingMaskIntoConstraints = false
        startGameButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            continueGameButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            continueGameButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 344),
            continueGameButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            continueGameButton.heightAnchor.constraint(equalToConstant: 56),
            
            startGameButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            startGameButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            startGameButton.heightAnchor.constraint(equalToConstant: 56),
        ])
    }
    
    private func updateUIForSavedGame() {
        if hasSavedGame {
            startGameButtonTopConstraint = startGameButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 412)
            startGameButtonTopConstraint?.isActive = true
            
            continueGameButton.isHidden = false
            startGameButton.isHidden = false
        } else {
            startGameButtonTopConstraint = startGameButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 360)
            startGameButtonTopConstraint?.isActive = true
            
            continueGameButton.isHidden = true
            startGameButton.isHidden = false
        }
    }
    
    @objc private func startButtonTapped() {
        coreData.deleteAllItems()
        self.navigationController?.pushViewController(GameViewController(), animated: true)
    }
    
    @objc private func continueButtonTapped() {
        self.navigationController?.pushViewController(GameViewController(), animated: true)
    }
}

