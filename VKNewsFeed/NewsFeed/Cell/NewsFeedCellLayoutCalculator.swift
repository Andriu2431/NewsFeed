//
//  NewsFeedCellLayoutCalculator.swift
//  VKNewsFeed
//
//  Created by Andriy on 29.07.2022.
//

import UIKit

//Протокол який має метод вираховування розміру
protocol FeedCellLayoutCalculatorProtocol {
    func sizes(postText: String?, photoAttachment: FeedCellPhotoAttachementViewModel?) -> FeedCellSizes
}

//Структура яка реалізовує протокол розмірів
struct Sizes: FeedCellSizes {
    var postLabelFrame: CGRect
    var attachementFrame: CGRect
    var bottomViewFrame: CGRect
    var totalHeight: CGFloat
}

//Це розміра елементів в контейнері
struct Constants {
    static let cardInsets = UIEdgeInsets(top: 0, left: 8, bottom: 12, right: 8)
    static let topViewHeight: CGFloat = 40
    static let postLabelInsets = UIEdgeInsets(top: 8 + Constants.topViewHeight + 8, left: 8, bottom: 8, right: 8)
    static let postLabelFont = UIFont.systemFont(ofSize: 15)
    static let bottomViewHeight: CGFloat = 44
}

//Файл який буде вираховувати розмір контейнера
final class FeedCellLayoutCalculator: FeedCellLayoutCalculatorProtocol {
    
    //Ширина нашого екрана
    private let screenWith: CGFloat
    
    //По дефолту передаємо ширину екрану 
    init(screenWith: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)) {
        self.screenWith = screenWith
    }
    
    //Функція яка вже буде рахувати розмір та вертати його через протокол FeedCellSizes
    func sizes(postText: String?, photoAttachment: FeedCellPhotoAttachementViewModel?) -> FeedCellSizes {
        
        //Отримуємо ширину cardView
        let cardViewWidth = screenWith - Constants.cardInsets.left - Constants.cardInsets.right
        
        //MARK: postLabelFrame
        var postLabelFrame = CGRect(origin: CGPoint(x: Constants.postLabelInsets.left, y: Constants.postLabelInsets.top),
                                    size: CGSize.zero)
        
        //Якщо текст є та він не пустий тоді працюємо з розміром
        if let text = postText, !text.isEmpty {
            //Ширина лейбла
            let width = cardViewWidth - Constants.postLabelInsets.left - Constants.postLabelInsets.right
            //Висота
            let height = text.height(width: width, font: Constants.postLabelFont)
            
            postLabelFrame.size = CGSize(width: width, height: height)
        }
        
        //MARK: attachementFrame
        
        //Якщо postLabelFrame = 0, тоді attachementTop = Constants.postLabelInsets.top, якащо postLabelFrame != 0, то postLabelFrame.maxY + Constants.postLabelInsets.bottom
        let attachementTop = postLabelFrame.size == CGSize.zero ? Constants.postLabelInsets.top : postLabelFrame.maxY + Constants.postLabelInsets.bottom
        
        var attachementFrame = CGRect(origin: CGPoint(x: 0, y: attachementTop),
                                    size: CGSize.zero)
        
        //Перевіремо чи прийшла фото
        if let attachment = photoAttachment {
            //Рахуємо співвідношення сторін фото яка прийде
            let photoHeight: Float = Float(attachment.height)
            let photoWidth: Float = Float(attachment.width)
            let ratio = photoHeight / photoWidth
            attachementFrame.size = CGSize(width: cardViewWidth, height: cardViewWidth * CGFloat(ratio))
        }
        
        //MARK: bottomViewFrame
        //Шукаємо більше значення з них
        let bottomViewTop = max(postLabelFrame.maxY, attachementFrame.maxY)
        
        let bottomViewFrame = CGRect(origin: CGPoint(x: 0, y: bottomViewTop),
                                     size: CGSize(width: cardViewWidth, height: Constants.bottomViewHeight))
        
        //MARK: totalHeight
        let totalHeight = bottomViewFrame.maxY + Constants.cardInsets.bottom
        
        return Sizes(postLabelFrame: postLabelFrame,
                     attachementFrame: attachementFrame,
                     bottomViewFrame: bottomViewFrame,
                     totalHeight: totalHeight)
    }
}
