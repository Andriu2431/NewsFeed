//
//  GalleryColectionView.swift
//  VKNewsFeed
//
//  Created by Andriy on 02.08.2022.
//

import UIKit

//Тут будемо створювати ColectionView

class GalleryColectionView: UICollectionView {
    
    //Масив фото яким буде заповнюватись ColectionView
    var photos = [FeedCellPhotoAttachementViewModel]()
    
    init() {
        //Як будуть розкладатись контейнери
        let layout = UICollectionViewFlowLayout()
        //Скажемо що він буде горизонтальним
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        
        delegate = self
        dataSource = self
        
        backgroundColor = .gray
        
        register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.reuseId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Мктод який приймає масив фоток для заповнення ColectionView
    func set(photos: [FeedCellPhotoAttachementViewModel]) {
        self.photos = photos
        reloadData()
    }
}


extension GalleryColectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.reuseId, for: indexPath) as! GalleryCollectionViewCell
        cell.set(imageUrl: photos[indexPath.row].photoUrlString)
        return cell
    }
    
    
}
