//
//  NewsFeedViewController.swift
//  VKNewsFeed
//
//  Created by Andriy on 24.07.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsFeedDisplayLogic: AnyObject {
    func displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData)
}

//Контроллер новин
class NewsFeedViewController: UIViewController, NewsFeedDisplayLogic {
    
    //Тримає бізнес логіку, але завязаний на протокол
    var interactor: NewsFeedBusinessLogic?
    var router: (NSObjectProtocol & NewsFeedRoutingLogic)?

    //Створюємо модель постів
    private var feedViewModel = FeedViewModel.init(cells: [])
    
    @IBOutlet weak var table: UITableView!
    
    // MARK: Setup
    //Створює всі залежності та показує залежності
    private func setup() {
        let viewController        = self
        let interactor            = NewsFeedInteractor()
        let presenter             = NewsFeedPresenter()
        let router                = NewsFeedRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }

    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        //Рейструємо контейнер через xib файл
        table.register(UINib(nibName: "NewsFeedCell", bundle: nil), forCellReuseIdentifier: NewsFeedCell.reuseId)
        
        title = "News Feed"
        //Колір view, table
        table.separatorStyle = .none
        table.backgroundColor = .clear
        view.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        
        //Відправляємо запит до interactor для отримання даних якими заповнимо контейнери.
        interactor?.makeRequest(request: .getNewsFeed)
    }
    
    //Метод приймає готові дані для відображення з моделі даних
    func displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData) {
        
        switch viewModel {
        case .displayNewsFeed(feedViewModel: let feedViewModel):
            //Заповнюємо модель постів тими поставми які отримуємо тут
            self.feedViewModel = feedViewModel
            table.reloadData()
        }
    }
}
    

//MARK: UITableViewDelegate, UITableViewDataSource

extension NewsFeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedCell.reuseId, for: indexPath) as! NewsFeedCell
        //Пост з моделі витягуємо по індексу
        let cellViewModel = feedViewModel.cells[indexPath.row]
        //Беремо пост по індексу та передаємо в метод який буде заповнювати контейнер данними
        cell.set(viewModel: cellViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //Беремо пост по indexPath
        let cellViewModel = feedViewModel.cells[indexPath.row]
        //В поста беремо розмір 
        return cellViewModel.sizes.totalHeight
    }
}
