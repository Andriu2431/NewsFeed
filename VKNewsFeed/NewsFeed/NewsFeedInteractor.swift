//
//  NewsFeedInteractor.swift
//  VKNewsFeed
//
//  Created by Andriy on 24.07.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsFeedBusinessLogic {
    func makeRequest(request: NewsFeed.Model.Request.RequestType)
}

//Тут бізнес логіка
class NewsFeedInteractor: NewsFeedBusinessLogic {
    
    var presenter: NewsFeedPresentationLogic?
    var service: NewsFeedService?
    
    func makeRequest(request: NewsFeed.Model.Request.RequestType) {
        if service == nil {
            service = NewsFeedService()
        }
        
        //Через switch будемо обробляти запит який передали сюди в метод
        switch request {
        case .some:
            print(".some Interactor")
        case .getFeed:
            print(".getFeed Interactor")
            //Передаємо дані в presenter
            presenter?.presentData(response: .presentNewsFeed)
        }
    }
    
}
