//
//  SceneDelegate.swift
//  VKNewsFeed
//
//  Created by Andriy on 19.07.2022.
//

import UIKit
import VKSdkFramework

class SceneDelegate: UIResponder, UIWindowSceneDelegate, AuthServiceDelegate {

    var window: UIWindow?
    var authService: AuthService!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        //Створюємо сцену
        let window = UIWindow(windowScene: windowScene)
        //Передаємо сцену
        self.window = window
        //Реазілуємо синглтин
        authService = AuthService.shared
        //Будемо реалізовувати делегата
        authService.delegate = self
        
        //Отримуємо контроллер та кастимо його до AuthViewController
        let authVC = UIStoryboard(name: "AuthViewController", bundle: nil).instantiateInitialViewController() as? AuthViewController
        
        //Або так - по ідентифікатору контроллера
//        let authVC = UIStoryboard(name: "AuthViewController", bundle: nil).instantiateViewController(withIdentifier: String(describing: AuthViewController.self)) as? AuthViewController
        
        window.rootViewController = authVC
        window.makeKeyAndVisible()
    }
    
    //Робимо запит авторизації по url
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            VKSdk.processOpen(url, fromApplication: UIApplication.OpenURLOptionsKey.sourceApplication.rawValue)
        }
    }
    
    //MARK: AuthServiceDelegate
    
    func authServiceShouldShow(_ viewController: UIViewController) {
        print(#function)
        window?.rootViewController?.present(viewController, animated: true, completion: nil)
    }
    
    func authServiceSignIn() {
        print(#function)
        let feedVC = UIStoryboard(name: "FeedViewController", bundle: nil).instantiateInitialViewController() as! FeedViewController
        let navVC = UINavigationController(rootViewController: feedVC)
        window?.rootViewController = navVC
    }
    
    func authServiceDidSignInFail() {
        print(#function)
    }
}

