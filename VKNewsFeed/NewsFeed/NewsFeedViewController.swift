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
class NewsFeedViewController: UIViewController, NewsFeedDisplayLogic, NewsFeedCodeCellDelegate {
 
    //Тримає бізнес логіку, але завязаний на протокол
    var interactor: NewsFeedBusinessLogic?
    var router: (NSObjectProtocol & NewsFeedRoutingLogic)?

    //Створюємо модель постів
    private var feedViewModel = FeedViewModel.init(cells: [])
    //Екземпляр TitleView
    private var titleView = TitleView()
    //Створимо refreshControl - індикатор для оновлення постів
    private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(UIRefreshControl().self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
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
        setupTopBars()
        setupTable()
    
        view.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        
        //Відправляємо запит до interactor для отримання даних якими заповнимо контейнери.
        interactor?.makeRequest(request: .getNewsFeed)
        //Запит данних про користувача
        interactor?.makeRequest(request: .getUser)
    }
    
    //Настройка table
    private func setupTable() {
        
        //Зробимо відстань між постом та titleView
        let topInsert: CGFloat = 8
        table.contentInset.top = topInsert
        
        //Рейструємо контейнер через xib файл
        table.register(UINib(nibName: "NewsFeedCell", bundle: nil), forCellReuseIdentifier: NewsFeedCell.reuseId)
        //Рейструємо контейнер через код
        table.register(NewsFeedCodeCell.self, forCellReuseIdentifier: NewsFeedCodeCell.reuseId)
        
        //Колір view, table
        table.separatorStyle = .none
        table.backgroundColor = .clear
        
        table.addSubview(refreshControl)
    }
    
    
    //Метод в якому будемо настроювати navBar
    private func setupTopBars() {
        //Позволяє скривати наш navBar коли ми гортаємо новини в низ
        self.navigationController?.hidesBarsOnSwipe = true
        //Скажемо що буде фотка в navBar
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //Присвоюємо кастомну view
        self.navigationItem.titleView = titleView
    }
    
    //Будемо оновляти стрічку з постами
    @objc private func refresh() {
        interactor?.makeRequest(request: .getNewsFeed)
    }
    
    //Метод приймає готові дані для відображення з моделі даних
    func displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData) {
        
        switch viewModel {
        case .displayNewsFeed(feedViewModel: let feedViewModel):
            //Заповнюємо модель постів тими поставми які отримуємо тут
            self.feedViewModel = feedViewModel
            table.reloadData()
            //Коли стрічка з постами загрузиться то виключимо refreshControl
            refreshControl.endRefreshing()
        case .displayUser(userViewModel: let userViewModel):
            //Тут вже сетим фотку
            titleView.set(userViewModel: userViewModel)
        }
    }
    
    //MARK: NewsFeedCodeCellDelegate
    
    func revealPost(for cell: NewsFeedCodeCell) {
        //Дізнаємось indexPath контейнера в якому хочемо розкрити текст
        guard let indexPath = table.indexPath(for: cell) else { return }
        //Отримуємо інформацію про контейнер який хочемо розкрити
        let cellViewModel = feedViewModel.cells[indexPath.row]
        
        //Запит до інтерактора
        interactor?.makeRequest(request: .revealPostIds(postId: cellViewModel.postId))
    }
}
    

//MARK: UITableViewDelegate, UITableViewDataSource

extension NewsFeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //це якщо через xib
//        let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedCell.reuseId, for: indexPath) as! NewsFeedCell
        
        //це якщо через код створюємо контейнер
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedCodeCell.reuseId, for: indexPath) as! NewsFeedCodeCell
        //Пост з моделі витягуємо по індексу
        let cellViewModel = feedViewModel.cells[indexPath.row]
        //Беремо пост по індексу та передаємо в метод який буде заповнювати контейнер данними
        cell.set(viewModel: cellViewModel)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //Беремо пост по indexPath
        let cellViewModel = feedViewModel.cells[indexPath.row]
        //В поста беремо розмір
        return cellViewModel.sizes.totalHeight
    }
}
