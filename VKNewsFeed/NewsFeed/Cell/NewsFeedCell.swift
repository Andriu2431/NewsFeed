//
//  NewsFeedCeel.swift
//  VKNewsFeed
//
//  Created by Andriy on 25.07.2022.
//

import UIKit

//Контейнер
class NewsFeedCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var sharesLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    
    
    
    //Ідентифікатор контейнера
    static let reuseId = "NewsFeedCell"
    
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
