//
//  AuthViewController.swift
//  VKNewsFeed
//
//  Created by Andriy on 19.07.2022.
//

import UIKit

class AuthViewController: UIViewController {
    
    private var authService: AuthService!

    override func viewDidLoad() {
        super.viewDidLoad()

        authService = AuthService.shared
    }
    
    @IBAction func signInTouch() {
        authService.wakeUpSession()
    }

}

