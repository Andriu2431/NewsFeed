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
        
        //Обробимо дані які передаємо в controller
        switch response {
        case .presentNewsFeed(feed: let feed):
            
            //Беремо масив постів, проходимось по ньому
            let cells = feed.items.map { feedItem in
                //Кожен пост приводимо до простих типві
                cellViewModel(from: feedItem)
            }
            
            //З масиву постів робимо дані для одного поста
            let feedViewModel = FeedViewModel(cells: cells)
            //Передаємо цей пост в ViewController
            viewController?.displayData(viewModel: .displayNewsFeed(feedViewModel: feedViewModel))
        }
    }
    
    //Метод в якому будемо робити потрібні нам дані
    private func cellViewModel(from feedItem: FeedItem) -> FeedViewModel.Cell {
        //Тобто в модель поста передаємо отриманні данні але в простих типах. Тобто ми маємо данні FeedItem але там вони в своїх типах а нам потрібно їх привести до простих типів FeedViewModel.Cell.
        return FeedViewModel.Cell.init(iconUrlString: "",
                                       name: "future name",
                                       date: "future date",
                                       text: feedItem.text,
                                       likes: String(feedItem.likes?.count ?? 0),
                                       comments: String(feedItem.comments?.count ?? 0),
                                       shares: String(feedItem.reposts?.count ?? 0),
                                       views: String(feedItem.views?.count ?? 0))
    }
}
