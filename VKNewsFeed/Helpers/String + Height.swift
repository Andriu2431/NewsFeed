//
//  StringWithHeight.swift
//  VKNewsFeed
//
//  Created by Andriy on 29.07.2022.
//

import UIKit

//Будемо рахувати висоту тексту
extension String {
    
    //Метод буде вираховувати висоту
    func height(width: CGFloat, font: UIFont) -> CGFloat {
        let textSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let size = self.boundingRect(with: textSize,
                                     options: .usesLineFragmentOrigin,
                                     attributes: [NSAttributedString.Key.font : font],
                                     context: nil)
        //Округляємо значення
        return ceil(size.height)
    }
}
