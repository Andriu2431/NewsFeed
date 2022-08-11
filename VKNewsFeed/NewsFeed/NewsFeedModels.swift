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
                case getUser
                case revealPostIds(postId: Int)
                case getNextBatch
            }
        }
        //Presenter
        struct Response {
            enum ResponseType {
                case presentNewsFeed(feed: FeedResponse, revealedPostIds: [Int])
                case presentUserInfo(user: UserResponse?)
                case presentFooterLoader
            }
        }
        //ViewController
        struct ViewModel {
            enum ViewModelData {
                case displayNewsFeed(feedViewModel: FeedViewModel)
                case displayUser(userViewModel: UserViewModel)
                case displayFooterLoader
            }
        }
    }
}

//Фото користувача
struct UserViewModel: TitleViewViewModel {
    var photoUrlString: String?
}

//Це пости
struct FeedViewModel {
    //Це один пост
    struct Cell: FeedCellViewModel {
        var postId: Int
        var iconUrlString: String
        var name: String
        var date: String
        var text: String?
        var likes: String?
        var comments: String?
        var shares: String?
        var views: String?
        var photoAttachments: [FeedCellPhotoAttachementViewModel]
        var sizes: FeedCellSizes
    }
    
    //Фото в пості
    struct FeedCellPhotoAttachement: FeedCellPhotoAttachementViewModel {
        var photoUrlString: String?        
        var width: Int
        var height: Int
    }
    
    //З постів в нас буде масив
    let cells: [Cell]
    
}
