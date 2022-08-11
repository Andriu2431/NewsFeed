//
//  NewsFeedWorker.swift
//  VKNewsFeed
//
//  Created by Andriy on 24.07.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

//Тут будемо робити запити замість interactora
class NewsFeedService {
    
    //Авторизація користувача
    var authService: AuthService
    //Запит
    var networking: NetworkingProtocol
    //Робимо запит та отримуємо данні
    var fetcher: DataFetcherProtocol

    //Масив postId тих постів в яких розвертаємо текст - будемо передавати його в presenter
    private var revealedPostIds = [Int]()
    //Створимо всластивість в яку передамо пости які прийшли
    private var feedResponse: FeedResponse?

    //Буде зберігати ключ через який будемо отримувати додаткові пости
    private var newFromInProsses: String?

    init() {
        self.authService = AuthService.shared
        self.networking = NetworkService(authService: authService)
        self.fetcher = NetworkDataFetcher(networking: networking)
    }

    //Метод в який буде вертати нам данні типу UserResponse
    func getUser(completion: @escaping (UserResponse?) -> Void) {
        fetcher.getUser { userResponse in
            completion(userResponse)
        }
    }

    //Метод в який буде вертати нам данні типу FeedResponse, та revealedPostIds
    func getFeed(completion: @escaping ([Int], FeedResponse) -> Void) {
        fetcher.getFeed(nextBatchFrom: nil) { [weak self] feed in
            self?.feedResponse = feed
            guard let feedResponse = self?.feedResponse else { return }
            completion(self!.revealedPostIds, feedResponse)
        }
    }

    //В revealedPostIds будемо додавати postId, для того коли будемо отримувати більше тексту в пості
    func revealedPostIds(forPostId postId: Int, completion: @escaping ([Int], FeedResponse) -> Void) {
        revealedPostIds.append(postId)
        guard let feedResponse = self.feedResponse else { return }
        completion(revealedPostIds, feedResponse)
    }

    //Метод який буде догружати пости
    func getNextBatch(completion: @escaping ([Int], FeedResponse) -> Void) {
        newFromInProsses = feedResponse?.nextFrom

        fetcher.getFeed(nextBatchFrom: newFromInProsses) { [weak self] feed in
            guard let feed = feed else { return }
            guard self?.feedResponse?.nextFrom != feed.nextFrom else { return }

            if self?.feedResponse == nil {
                self?.feedResponse = feed
            } else {
                //feedResponse заповнимо новими постами
                self?.feedResponse?.items.append(contentsOf: feed.items)

                var profiles = feed.profiles
                //Перевіримо чи є старі профілі
                if let oldProfiles = self?.feedResponse?.profiles {

                    let oldProfilesFiltered = oldProfiles.filter { oldProfiles in
                        //при кожній ітерації значення будемо добавляти в масив oldProfilesFiltered якщо з всього списку нових профілів не буде ніодного профіля з тим же ID
                        !feed.profiles.contains(where: { $0.id == oldProfiles.id })
                    }

                    profiles.append(contentsOf: oldProfilesFiltered)
                }
                self?.feedResponse?.profiles = profiles


                var groups = feed.groups
                if let oldGroups = self?.feedResponse?.groups {

                    let oldGroupsFiltered = oldGroups.filter { oldGroup in
                        !feed.groups.contains(where: { $0.id == oldGroup.id })
                    }

                    groups.append(contentsOf: oldGroupsFiltered)
                }
                self?.feedResponse?.groups = groups

                self?.feedResponse?.nextFrom = feed.nextFrom
            }
            guard let feedResponse = self?.feedResponse else { return }
            completion(self!.revealedPostIds, feedResponse)
        }
    }
}
