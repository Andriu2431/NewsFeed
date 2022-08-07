//
//  TitleView.swift
//  VKNewsFeed
//
//  Created by Andriy on 07.08.2022.
//

import Foundation
import UIKit

//Протокол для того щоб отримати лінку на фото
protocol TitleViewViewModel {
    var photoUrlString: String? { get }
}

//Будемо робити View який поставим на navigationBar
class TitleView: UIView {
    
    //Фото юзера
    private var myAvatarView: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    //Тест філд ініціалізуємо через кастомний клас
    private var myTextField = InsetableTextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(myTextField)
        addSubview(myAvatarView)
        
        makeConstraints()
    }
    
    //Метод в якому будемо задавати фото myAvatarView
    func set(userViewModel: TitleViewViewModel) {
        myAvatarView.set(imageURL: userViewModel.photoUrlString)
    }
    
    //Констрейни для myTextField та myAvatarView
    private func makeConstraints() {
        
        //myAvatarView Constraints
        myAvatarView.anchor(top: topAnchor,
                            leading: nil,
                            bottom: nil,
                            trailing: trailingAnchor,
                            padding: UIEdgeInsets(top: 4, left: 777, bottom: 777, right: 4))
        myAvatarView.heightAnchor.constraint(equalTo: myTextField.heightAnchor, multiplier: 1).isActive = true
        myAvatarView.widthAnchor.constraint(equalTo: myTextField.heightAnchor, multiplier: 1).isActive = true
        
        //myTextField Constraints
        myTextField.anchor(top: topAnchor,
                           leading: leadingAnchor,
                           bottom: bottomAnchor,
                           trailing: myAvatarView.leadingAnchor,
                           padding: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 12))
    }
    
    //Скажемо щоб view підстроювалась під розмір navBar
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        myAvatarView.layer.masksToBounds = true
        myAvatarView.layer.cornerRadius = myAvatarView.frame.width / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
