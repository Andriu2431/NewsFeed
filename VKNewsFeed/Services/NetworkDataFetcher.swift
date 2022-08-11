//
//  NetworkDataFetcher.swift
//  VKNewsFeed
//
//  Created by Andriy on 23.07.2022.
//

import Foundation

//Протокол який буде перетворювати отримані JSON дані в формат який нам потрібен
protocol DataFetcherProtocol {
    func getFeed(nextBatchFrom: String?, response: @escaping (FeedResponse?) -> Void)
    func getUser(response: @escaping (UserResponse?) -> Void)
}

//6 відео 16 хв
struct NetworkDataFetcher: DataFetcherProtocol {
    
    //Екземпляри
    let networking: NetworkingProtocol
    private let authService: AuthService
    
    init(networking: NetworkingProtocol, authService: AuthService = AuthService.shared) {
        self.networking = networking
        self.authService = authService
    }
    
    //Отримуємо дані в потрібному форматі - тобто отримуємо уже пости
    func getFeed(nextBatchFrom: String?, response: @escaping (FeedResponse?) -> Void) {
        var params = ["filters": "post,photo"]
        params["start_from"] = nextBatchFrom
        
        //Робимо запит
        networking.request(path: API.newsFeed, params: params) { data, error in
            if let error = error {
                print("Error recevied requesting data \(error.localizedDescription)")
                response(nil)
            }
            
            //Викличимо метод який декодує нам відповідь
            let decoded = self.decodeJSON(type: FeedResponseWrapped.self, from: data)
            //Передамо відповідь(пости) в замикання
            response(decoded?.response)
        }
    }
    
    //Запит для отримання данних про користувача
    func getUser(response: @escaping (UserResponse?) -> Void) {
        
        //Отримаємо userId
        guard let userId = authService.userId else { return }
        let params = ["user_ids": userId, "fields": "photo_100"]
        
        //Запит
        networking.request(path: API.user, params: params) { data, error in
            if let error = error {
                print("Error recevied requesting data \(error.localizedDescription)")
                response(nil)
            }
            
            let decoded = self.decodeJSON(type: UserResponseWrapped.self, from: data)
            response(decoded?.response.first)
        }
    }
    
    
    //Метод буде робити загальний response, для того щоб не робити його багато разів зробимо один раз та протсо будемо викликати цей метод
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = from, let response = try? decoder.decode(type.self, from: data) else { return nil }
        return response
    }

}


