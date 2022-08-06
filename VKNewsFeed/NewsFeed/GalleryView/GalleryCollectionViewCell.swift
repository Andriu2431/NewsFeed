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
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = #colorLiteral(red: 0.9117177725, green: 0.918438971, blue: 0.927837193, alpha: 1)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //Округлим фото та задамо тіні
        myImageView.layer.masksToBounds = true
        myImageView.layer.cornerRadius = 10
        self.layer.shadowRadius = 3
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 2.5, height: 4)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
