//
//  NewsFeedCeel.swift
//  VKNewsFeed
//
//  Created by Andriy on 25.07.2022.
//

import UIKit

//Модель повинна тримати в собі лише данні про @IBOutlet, для цього створимо протокол через який будемо реалізлвувати модель
//Реалізує модель данних
protocol FeedCellViewModel {
    var iconUrlString: String { get }
    var photoAttachment: FeedCellPhotoAttachementViewModel? { get }
    var name: String { get }
    var date: String { get }
    var text: String? { get }
    var likes: String? { get }
    var comments: String? { get }
    var shares: String? { get }
    var views: String? { get }
    var sizes: FeedCellSizes { get }
}

//Протокол який тримає розміри тексту поста та розмір фото для поста, та розмір нижньої панелі
protocol FeedCellSizes {
    var postLabelFrame: CGRect { get }
    var attachementFrame: CGRect { get }
    var bottomViewFrame: CGRect { get }
    var totalHeight: CGFloat  { get }
}

//Протокол який реалізовує фотографії для поста
protocol FeedCellPhotoAttachementViewModel {
    var photoUrlString: String? { get }
    var width: Int { get }
    var height: Int { get }
}

//Контейнер
class NewsFeedCell: UITableViewCell {
    
    //Ідентифікатор контейнера
    static let reuseId = "NewsFeedCell"
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var iconImageView: WebImageView!
    @IBOutlet weak var postImageView: WebImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var sharesLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    //Готовить контейнер для багатовикористання
    override func prepareForReuse() {
        iconImageView.set(imageURL: nil)
        postImageView.set(imageURL: nil)

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Округлимо іконку групи або профіля
        iconImageView.layer.cornerRadius = iconImageView.frame.width / 2
        iconImageView.clipsToBounds = true
        
        //Верхнє view заокруглим для того щоб контейнер був як скруглений
        cardView.layer.cornerRadius = 10
        cardView.clipsToBounds = true
        
        backgroundColor = .clear
        //Щоб контейнер при нажиманні не виділявся
        selectionStyle = .none
    }
    
    //Метод через який будемо отримувати данні з ViewControllera - передавати будемо через модель данних, модель буде завязана на протоколі тому приймаємо тип протокола. Дані зразу присвоюємо
    func set(viewModel: FeedCellViewModel) {
        iconImageView.set(imageURL: viewModel.iconUrlString)
        nameLabel.text = viewModel.name
        dateLabel.text = viewModel.date
        postLabel.text = viewModel.text
        likesLabel.text = viewModel.likes
        commentsLabel.text = viewModel.comments
        sharesLabel.text = viewModel.shares
        viewsLabel.text = viewModel.views
        
        postLabel.frame = viewModel.sizes.postLabelFrame
        postImageView.frame = viewModel.sizes.attachementFrame
        bottomView.frame = viewModel.sizes.bottomViewFrame
        
        //Перевіремо чи отримали ми фото поста
        if let photoAttachment = viewModel.photoAttachment {
            postImageView.set(imageURL: photoAttachment.photoUrlString)
            postImageView.isHidden = false
        } else {
            //Там де нема фото то postImageView скриваєм
            postImageView.isHidden = true
        }
    }
}
