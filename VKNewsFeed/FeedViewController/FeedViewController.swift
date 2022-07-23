//
//  FeedViewController.swift
//  VKNewsFeed
//
//  Created by Andriy on 22.07.2022.
//

import UIKit

class FeedViewController: UIViewController {
    
    //Передаємо NetworkService через який зробили запит та оримаємо відповідь
    private var fetcher: DataFetcherProtocol = NetworkDataFetcher(networking: NetworkService())

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1)
        
        
        fetcher.getFeed { feedResponse in
            //Пости
            guard let feedResponse = feedResponse else { return }
            
            //Будемо проходитись по всім постам які отримуємо
            feedResponse.items.map({ feedItem in
                print(feedItem.date)
            })
        }
    }

}
