//
//  NewsFeedCellLayoutCalculator.swift
//  VKNewsFeed
//
//  Created by Andriy on 29.07.2022.
//

import UIKit

//Протокол який має метод вираховування розміру
protocol FeedCellLayoutCalculatorProtocol {
    func sizes(postText: String?, photoAttachments: [FeedCellPhotoAttachementViewModel]) -> FeedCellSizes
}

//Структура яка реалізовує протокол розмірів
struct Sizes: FeedCellSizes {
    var postLabelFrame: CGRect
    var moreTextButtonFrame: CGRect
    var attachementFrame: CGRect
    var bottomViewFrame: CGRect
    var totalHeight: CGFloat
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
    func sizes(postText: String?, photoAttachments: [FeedCellPhotoAttachementViewModel]) -> FeedCellSizes {
        
        //Перевіримо чи текст прийшов більший ніж дозволено чи ні
        var showMoreTextButton = false
        
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
            var height = text.height(width: width, font: Constants.postLabelFont)
            
            //Отримуємо який ліміт по тексту
            let limitHeight = Constants.postLabelFont.lineHeight * Constants.minifiedPostLimitLines
            
            //Перевіримо чи висота тексту більша за дозволену висоту
            if height > limitHeight {
                //Задамо дозволену висоту для тексту
                height = Constants.postLabelFont.lineHeight * Constants.minifiedPostLines
                showMoreTextButton = true
            }
            
            postLabelFrame.size = CGSize(width: width, height: height)
        }
        
        //MARK: moreTextButtonFrame
        //Розмір кнопки
        var moreTextButtonSize = CGSize.zero
        
        //Перевіримо чи був текст більший чи ні
        if showMoreTextButton {
            //Якщо розмір прийшов більший то задаємо розмір кнопки, щоб вона була на екрані
            moreTextButtonSize = Constants.moreTextButtonSize
        }
        
        //Місце розташування на екрані задамо
        let moreTextButtonOrigin = CGPoint(x: Constants.moreTextButtonInsets.left, y: postLabelFrame.maxY)
        
        //Задали розміра та розположення кнопки
        let moreTextButtonFrame = CGRect(origin: moreTextButtonOrigin, size: moreTextButtonSize)
        
        //MARK: attachementFrame
        
        //Якщо postLabelFrame = 0, тоді attachementTop = Constants.postLabelInsets.top, якащо postLabelFrame != 0, то moreTextButtonFrame.maxY + Constants.postLabelInsets.bottom
        let attachementTop = postLabelFrame.size == CGSize.zero ? Constants.postLabelInsets.top : moreTextButtonFrame.maxY + Constants.postLabelInsets.bottom
        
        var attachementFrame = CGRect(origin: CGPoint(x: 0, y: attachementTop),
                                      size: CGSize.zero)
        
        //Перевіремо чи прийшла фото, якщо так то скільки їх
        if let attachment = photoAttachments.first {
            //Рахуємо співвідношення сторін фото яка прийде
            let photoHeight: Float = Float(attachment.height)
            let photoWidth: Float = Float(attachment.width)
            let ratio = photoHeight / photoWidth
            
            //Якщо фотка лише одна
            if photoAttachments.count == 1 {
                attachementFrame.size = CGSize(width: cardViewWidth, height: cardViewWidth * CGFloat(ratio))
            } else if photoAttachments.count > 1 {
                //Якщо більше ніж одна фото
                attachementFrame.size = CGSize(width: cardViewWidth, height: cardViewWidth * CGFloat(ratio))
            }
        }
        
        //MARK: bottomViewFrame
        //Шукаємо більше значення з них
        let bottomViewTop = max(postLabelFrame.maxY, attachementFrame.maxY)
        
        let bottomViewFrame = CGRect(origin: CGPoint(x: 0, y: bottomViewTop),
                                     size: CGSize(width: cardViewWidth, height: Constants.bottomViewHeight))
        
        //MARK: totalHeight
        let totalHeight = bottomViewFrame.maxY + Constants.cardInsets.bottom
        
        return Sizes(postLabelFrame: postLabelFrame,
                     moreTextButtonFrame: moreTextButtonFrame,
                     attachementFrame: attachementFrame,
                     bottomViewFrame: bottomViewFrame,
                     totalHeight: totalHeight)
    }
}
