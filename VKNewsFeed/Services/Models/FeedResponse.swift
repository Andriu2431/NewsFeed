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

//Один пост
struct FeedResponse: Decodable {
    var items: [FeedItem]
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



//https://api.vk.com/method/newsfeed.get?filters=post,photo&v=5.131&access_token=vk1.a.RW7I8-IVHZXc3H6Yn1cdbpFI1n3rN5ruIEuJFhMAaEqlemT9mXehsHHcs5RFrdX2QxxfX4qXiTne3L5rluRU4xVbOpUx0slpVYuUDCnD5D12NC7f46CV9hkw3cZeMbP6Z8Y5GzspHAtFyhxmgcF9Nl4FO_WNVA2UfwhnJ54kNFrzxAn5YJjEESwYvgYMl3W4
