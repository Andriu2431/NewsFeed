//
//  WebImageView.swift
//  VKNewsFeed
//
//  Created by Andriy on 28.07.2022.
//

import UIKit

//Тут отримуємо фото поста через url
class WebImageView: UIImageView {
    
    func set(imageURL: String?) {
        
        //Витягуємо фото
        guard let imageURL = imageURL, let url = URL(string: imageURL) else {
            self.image = nil
            return }
        
        //Перевіримо чи є вже така фотка в кеші, для того щоб одну і туж фотку не підгружати пару разів
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            //Якщо вже я така фотка то передаємо її
            self.image = UIImage(data: cachedResponse.data)
            return
        }

        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            //Для того щоб не затримувати апку робимо асинхронно
            DispatchQueue.main.async {
                if let data = data, let response = response {
                    //ініціалізуємо фото через data
                    self?.image = UIImage(data: data)
                    //Добавляємо фотку в кеш
                    self?.handleLoadedImage(data: data, response: response)
                }
            }
        }
        dataTask.resume()
    }
    
    //Метод який буде поміщати фото в кеш
    private func handleLoadedImage(data: Data, response: URLResponse) {
        guard let responseURL = response.url else { return }
        //Отримуємо відповідь на запит
        let cachedResponse = CachedURLResponse(response: response, data: data)
        //Звертаємось де будемо його зберігати
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseURL))
    }
}
