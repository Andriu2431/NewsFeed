//
//  UserResponse.swift
//  VKNewsFeed
//
//  Created by Andriy on 07.08.2022.
//

import Foundation
//Тут будемо отримувати данні про користувача

struct UserResponseWrapped: Decodable {
    let response: [UserResponse]
}


struct UserResponse: Decodable {
    let photo100: String?
}
