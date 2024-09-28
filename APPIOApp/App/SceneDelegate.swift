//
//  SceneDelegate.swift
//  APPIOApp
//
//  Created by Ваня Сокол on 20.09.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    private let coreData = CoreDataService.shared
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let welcomeViewController = WelcomeViewController()
        checkIfHasSavedGame(in: welcomeViewController)
        configureNavigationBar()
        window?.rootViewController = UINavigationController(rootViewController: welcomeViewController)
        window?.makeKeyAndVisible()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        coreData.saveContext()
    }

    private func configureNavigationBar() {
        UINavigationBar.appearance().prefersLargeTitles = false
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor.white]
    }
    
    private func checkIfHasSavedGame(in welcomeViewController: WelcomeViewController) {
        if !coreData.getAllItems().isEmpty {
            welcomeViewController.hasSavedGame = true
        }
    }
}

