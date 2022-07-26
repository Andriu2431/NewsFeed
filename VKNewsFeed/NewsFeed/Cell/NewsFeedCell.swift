//
//  NewsFeedCeel.swift
//  VKNewsFeed
//
//  Created by Andriy on 25.07.2022.
//

import UIKit

//Модель повинна тримати в собі лише данні про @IBOutlet, для цього створимо протокол через який будемо реалізлвувати модель
protocol FeedCellViewModel {
    var iconUrlString: String { get }
    var name: String { get }
    var date: String { get }
    var text: String? { get }
    var likes: String? { get }
    var comments: String? { get }
    var shares: String? { get }
    var views: String? { get }
}

//Контейнер
class NewsFeedCell: UITableViewCell {
    
    //Ідентифікатор контейнера
    static let reuseId = "NewsFeedCell"
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var sharesLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //Метод через який будемо отримувати данні з ViewControllera - передавати будемо через модель данних, модель буде завязана на протоколі тому приймаємо тип протокола. Дані зразу присвоюємо
    func set(viewModel: FeedCellViewModel) {
        nameLabel.text = viewModel.name
        dateLabel.text = viewModel.date
        postLabel.text = viewModel.text
        likesLabel.text = viewModel.likes
        commentsLabel.text = viewModel.comments
        sharesLabel.text = viewModel.shares
        viewsLabel.text = viewModel.views
    }
}
