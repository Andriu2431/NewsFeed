//
//  NetworkDataFetcher.swift
//  VKNewsFeed
//
//  Created by Andriy on 23.07.2022.
//

import Foundation

//Протокол який буде перетворювати отримані JSON дані в формат який нам потрібен
protocol DataFetcherProtocol {
    func getFeed(response: @escaping (FeedResponse?) -> Void)
}

//6 відео 16 хв
struct NetworkDataFetcher: DataFetcherProtocol {
    
    let networking: NetworkingProtocol
    
    init(networking: NetworkingProtocol) {
        self.networking = networking
    }
    
    //Отримуємо дані в потрібному форматі - тобто отримуємо уже пости
    func getFeed(response: @escaping (FeedResponse?) -> Void) {
        let params = ["filters": "post,photo"]
        
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
    
    //Метод буде робити загальний response, для того щоб не робити його багато разів зробимо один раз та протсо будемо викликати цей метод
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = from, let response = try? decoder.decode(type.self, from: data) else { return nil }
        return response
    }

}


