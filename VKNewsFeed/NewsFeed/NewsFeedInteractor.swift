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
    //Worker
    var service: NewsFeedService?
    
    //Передаємо NetworkService через який зробили запит та оримаємо відповідь
    private var fetcher: DataFetcherProtocol = NetworkDataFetcher(networking: NetworkService())
    
    func makeRequest(request: NewsFeed.Model.Request.RequestType) {
        if service == nil {
            service = NewsFeedService()
        }
        
        //Через switch будемо обробляти запит який передали сюди в метод
        switch request {
        case .getNewsFeed:
            //Робимо запит та отримуємо пости
            fetcher.getFeed { [weak self] feedResponse in
                
                guard let feedResponse = feedResponse else { return }
                
                //Передаємо пости в Presenter
                self?.presenter?.presentData(response: .presentNewsFeed(feed: feedResponse))
            }
        }
    }
}
