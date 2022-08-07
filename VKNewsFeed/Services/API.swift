//
//  API.swift
//  VKNewsFeed
//
//  Created by Andriy on 22.07.2022.
//

import Foundation

//Тут будуть компоненти дял запиту
struct API {
    static let scheme = "https"
    static let host = "api.vk.com"
    static let version = "5.131"
    static let newsFeed = "/method/newsfeed.get"
    static let user = "/method/users.get"
}
