//
//  NetworkService.swift
//  VKNewsFeed
//
//  Created by Andriy on 22.07.2022.
//

import Foundation

protocol NetworkingProtocol {
    func request(path: String, params: [String: String], completion: @escaping (Data?, Error?) -> Void)
}

//Тут буде робота з API Vk
final class NetworkService: NetworkingProtocol {
    
    private let authService: AuthService
    
    //Ініціалізуємо authService
    init(authService: AuthService = AuthService.shared) {
        self.authService = authService
    }
    
    //Метод створить парамитри запиту за зробить request
    func request(path: String, params: [String: String], completion: @escaping (Data?, Error?) -> Void) {
        guard let token = authService.token else { return }

        //Розширимо наші параметри
        var allParams = params
        allParams["access_token"] = token
        allParams["v"] = API.version
        let url = self.url(from: path, params: allParams)

        //Робимо запит по url
        let request = URLRequest(url: url)
        //Робимо запит по request та відповідь передаємо в замиканні
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    //Метод створить задачу а відповідь передасть в замикання
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
    
    //Метод який створить Url
    private func url(from path: String, params: [String: String]) -> URL {
        var components = URLComponents()
        
        components.scheme = API.scheme
        components.host = API.host
        components.path = path
        //Заповнимо queryItems словником params - $0 це перше значенян словника(filters), $1 друге(post,photo)
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        
        return components.url!
    }
}


