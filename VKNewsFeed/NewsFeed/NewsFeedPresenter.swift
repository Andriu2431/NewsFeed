//
//  NewsFeedPresenter.swift
//  VKNewsFeed
//
//  Created by Andriy on 24.07.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsFeedPresentationLogic {
    func presentData(response: NewsFeed.Model.Response.ResponseType)
}

//Будемо створювати прості дані які передамо в контроллер - тобто дані готові для відображення
class NewsFeedPresenter: NewsFeedPresentationLogic {
    weak var viewController: NewsFeedDisplayLogic?
    
    func presentData(response: NewsFeed.Model.Response.ResponseType) {
        
        //Обробимо дані які передаємо через switch
        switch response {
        case .some:
            print(".some Presenter")
        case .presentNewsFeed:
            print(".presentNewsFeed Presenter")
            //Передамо дані для відображення в viewController
            viewController?.displayData(viewModel: .displayNewsFeed)
        }
    }
    
}
