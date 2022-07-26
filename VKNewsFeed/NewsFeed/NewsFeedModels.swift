//
//  NewsFeedModels.swift
//  VKNewsFeed
//
//  Created by Andriy on 24.07.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit


//Модель данних
enum NewsFeed {
    
    enum Model {
        //Iteractor
        struct Request {
            enum RequestType {
                case getNewsFeed
            }
        }
        //Presenter
        struct Response {
            enum ResponseType {
                case presentNewsFeed(feed: FeedResponse)
            }
        }
        //ViewController
        struct ViewModel {
            enum ViewModelData {
                case displayNewsFeed(feedViewModel: FeedViewModel)
            }
        }
    }
}

//Це пости
struct FeedViewModel {
    //Це один пост
    struct Cell: FeedCellViewModel {
        var iconUrlString: String
        var name: String
        var date: String
        var text: String?
        var likes: String?
        var comments: String?
        var shares: String?
        var views: String?
    }
    
    //З постів в нас буде масив
    let cells: [Cell]
    
}
