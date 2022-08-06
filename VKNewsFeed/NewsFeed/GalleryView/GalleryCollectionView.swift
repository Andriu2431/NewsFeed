//
//  GalleryColectionView.swift
//  VKNewsFeed
//
//  Created by Andriy on 02.08.2022.
//

import UIKit

//Тут будемо створювати ColectionView

class GalleryColectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //Масив фото яким буде заповнюватись ColectionView
    var photos = [FeedCellPhotoAttachementViewModel]()
    
    init() {
        let rowLayout = RowLayout()
        super.init(frame: .zero, collectionViewLayout: rowLayout)
        
        delegate = self
        dataSource = self
        rowLayout.delegate = self
        
        backgroundColor = .white
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.reuseId)
    }
    
    //Мктод який приймає масив фоток для заповнення ColectionView
    func set(photos: [FeedCellPhotoAttachementViewModel]) {
        self.photos = photos
        contentOffset = CGPoint.zero
        reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.reuseId, for: indexPath) as! GalleryCollectionViewCell
        cell.set(imageUrl: photos[indexPath.row].photoUrlString)
        return cell
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension GalleryColectionView: RowLayoutDelegate {
    
    //Вертаємо розмір фото
    func collectionView(_ collectionView: UICollectionView, photoAtIndexPath indexPath: IndexPath) -> CGSize {
        //Витягуємо ширину
        let width = photos[indexPath.row].width
        let height = photos[indexPath.row].height
        
        return CGSize(width: width, height: height)
    }
}
