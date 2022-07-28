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
    
    var dateFormater: DateFormatter {
        let dt = DateFormatter()
        dt.locale = Locale(identifier: "uk_UK")
        dt.dateFormat = "d MMM 'в' HH:mm"
        return dt
    }

    func presentData(response: NewsFeed.Model.Response.ResponseType) {

        //Обробимо дані які передаємо в controller
        switch response {
        case .presentNewsFeed(feed: let feed):

            //Беремо масив постів, проходимось по ньому
            let cells = feed.items.map { feedItem in
                //Кожен пост приводимо до простих типві
                cellViewModel(from: feedItem, profiles: feed.profiles, groups: feed.groups)
            }

            //З масиву постів робимо дані для одного поста
            let feedViewModel = FeedViewModel(cells: cells)
            //Передаємо цей пост в ViewController
            viewController?.displayData(viewModel: .displayNewsFeed(feedViewModel: feedViewModel))
        }
    }

    //Метод в якому будемо робити потрібні нам дані
    private func cellViewModel(from feedItem: FeedItem, profiles: [Profile], groups: [Group]) -> FeedViewModel.Cell {

        let profile = self.profile(for: feedItem.sourceId, profiles: profiles, groups: groups)
        
        let date = Date(timeIntervalSince1970: feedItem.date)
        let dateTitle = dateFormater.string(from: date)

        //Тобто в модель поста передаємо отриманні данні але в простих типах. Тобто ми маємо данні FeedItem але там вони в своїх типах а нам потрібно їх привести до простих типів FeedViewModel.Cell.
        return FeedViewModel.Cell.init(iconUrlString: profile.photo,
                                       name: profile.name,
                                       date: dateTitle,
                                       text: feedItem.text,
                                       likes: String(feedItem.likes?.count ?? 0),
                                       comments: String(feedItem.comments?.count ?? 0),
                                       shares: String(feedItem.reposts?.count ?? 0),
                                       views: String(feedItem.views?.count ?? 0))
    }

    //Метод який буде шукати інформацію для користувача
    private func profile(for sourseId: Int, profiles: [Profile], groups: [Group]) -> ProfileRepresentable {

        //Якщо sourseId більше 0 то заповнюємо користувачами, якщо ні то групами
        let profilesOrGroups: [ProfileRepresentable] = sourseId >= 0 ? profiles : groups
        //Якщо більше 0 то присвоюємо sourseId якщо ні то міняємо знак
        let normalSourseId = sourseId >= 0 ? sourseId : -sourseId
        //Проходимось по масиву profilesOrGroups та перший в якого числа співпали ми запамятовуємо
        let profileRepresentable = profilesOrGroups.first { myProfileRepresentable -> Bool in
            myProfileRepresentable.id == normalSourseId
        }

        return profileRepresentable!
    }
}


