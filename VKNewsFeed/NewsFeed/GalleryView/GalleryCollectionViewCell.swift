//
//  GalleryCollectionViewCell.swift
//  VKNewsFeed
//
//  Created by Andriy on 02.08.2022.
//

import UIKit

//Контейнер для ColectionView

class GalleryCollectionViewCell: UICollectionViewCell {
    
    //Ідентифікатор
    static let reuseId = "GalleryCollectionViewCell"
    
    //Фото з поста
    let myImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .yellow
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        addSubview(myImageView)
        
        //myImageView constraints
        //Заповнює все пространство контейнера
        myImageView.fillSuperview()
    }
    
    override func prepareForReuse() {
        myImageView.image = nil
    }
    
    //Методя кий приймає силку для скачування фото
    func set(imageUrl: String?) {
        myImageView.set(imageURL: imageUrl)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
