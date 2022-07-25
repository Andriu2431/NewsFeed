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
                case some
                case getFeed
            }
        }
        //Presenter
        struct Response {
            enum ResponseType {
                case some
                case presentNewsFeed
            }
        }
        //ViewController
        struct ViewModel {
            enum ViewModelData {
                case some
                case displayNewsFeed
            }
        }
    }
    
}
