//
//  FeedResponse.swift
//  VKNewsFeed
//
//  Created by Andriy on 23.07.2022.
//

import Foundation
//Тут будемо опрацьовувати формат данних які приходять - JSON в модесь яку створимо тут

//Структура яка приймає відповідь - пости
struct FeedResponseWrapped: Decodable {
    let response: FeedResponse
}


struct FeedResponse: Decodable {
    //Масив з інформацією в постах
    var items: [FeedItem]
    //Масив користувачів
    var profiles: [Profile]
    //Масив груп
    var groups: [Group]
}

//Інформація в пості
struct FeedItem: Decodable {
    let sourceId: Int
    let postId: Int
    let text: String?
    let date: Double
    let comments: CountableItem?
    let likes: CountableItem?
    let reposts: CountableItem?
    let views: CountableItem?
}

//Кількість лайків, коментів...
struct CountableItem: Decodable {
    let count: Int
}

//Створимо протокол для простоти
protocol ProfileRepresentable {
    var id: Int { get }
    var name: String { get }
    var photo: String { get }
}

//Інформація по користувача від кого пост
struct Profile: Decodable, ProfileRepresentable {
    let id: Int
    let firstName: String
    let lastName: String
    let photo100: String
    
    var name: String { return firstName + " " + lastName }
    var photo: String { return photo100 }
}

//Інформація про групу від якої пост
struct Group: Decodable, ProfileRepresentable {
    let id: Int
    let name: String
    let photo100: String
    
    var photo: String { return photo100 }
}


//https://api.vk.com/method/newsfeed.get?filters=post,photo&v=5.131&access_token=vk1.a.RW7I8-IVHZXc3H6Yn1cdbpFI1n3rN5ruIEuJFhMAaEqlemT9mXehsHHcs5RFrdX2QxxfX4qXiTne3L5rluRU4xVbOpUx0slpVYuUDCnD5D12NC7f46CV9hkw3cZeMbP6Z8Y5GzspHAtFyhxmgcF9Nl4FO_WNVA2UfwhnJ54kNFrzxAn5YJjEESwYvgYMl3W4
