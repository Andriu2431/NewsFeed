//
//  RowLayout .swift
//  VKNewsFeed
//
//  Created by Andriy on 06.08.2022.
//

import Foundation
import UIKit

//Протокол делегат
protocol RowLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, photoAtIndexPath indexPath: IndexPath) -> CGSize
}

//Тут буде кастомний RowLayout для collectionView - будемо настроювати розмір для collectionView
class RowLayout: UICollectionViewLayout {

    //Силка на делегат
    weak var delegate: RowLayoutDelegate!

    //Кількість строк
    static var numbersOfRows = 2
    //Відсупи від країв
    fileprivate var cellPadding: CGFloat = 8

    //Масив для кешуємих вираховуємих атрибутів - розмір та розположення
    fileprivate var cache = [UICollectionViewLayoutAttributes]()

    //Ширина контента
    fileprivate var contentWidth: CGFloat = 0
    //Константа
    fileprivate var contentHeight: CGFloat {
        guard let collectionView = collectionView else { return 0}
        let insets = collectionView.contentInset
        return collectionView.bounds.height - (insets.left + insets.right)
    }

    //Розмір контента
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    //Метод спрацьовує коли ми хочемо щось зробити
    override func prepare() {
        contentWidth = 0
        cache = []
        //Ми будемо розраховувати атрибути, тільки якщо cache пустий та collectionView є
        guard cache.isEmpty == true, let collectionView = collectionView else { return }

        //Дістаємо всі розміра фото
        var photos = [CGSize]()
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            //Отримуємо indexPath
            let indexPath = IndexPath(item: item, section: 0)
            //по indexPath витягуємо розмір фото
            let photoSize = delegate.collectionView(collectionView, photoAtIndexPath: indexPath)
            photos.append(photoSize)
        }

        let superViewWidth = collectionView.frame.width

        //Запитаємо висоту самого малого фото
        guard var rowHeight = RowLayout.rowHeightCounter(superViewWidth: superViewWidth, photosArray: photos) else { return }

        rowHeight = rowHeight / CGFloat(RowLayout.numbersOfRows)

        //Масив який тримає в собі співвідношення сторін для кожної фото
        let photosRatios = photos.map { $0.height / $0.width }

        var yOffset = [CGFloat]()
        for row in 0 ..< RowLayout.numbersOfRows {
            yOffset.append(CGFloat(row) * rowHeight)
        }

        var xOffset = [CGFloat](repeating: 0, count: RowLayout.numbersOfRows)

        //В якій ми зара строці находимось
        var row = 0

//        Перебераємо всі елементи collectionView - задаємо розмір для кожного контейнера, та фіксуємо місцезнаходження за допомогою yOfset та xOfset
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)

            //Витягуємо співвідношення сторін для кожної фото
            let ratios = photosRatios[indexPath.row]
            //Ширина цієї фото
            let widht = (rowHeight / ratios)

            //Розмір фото
            let frame = CGRect(x: xOffset[row], y: yOffset[row], width: widht, height: rowHeight)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)

            //Коніертуємо insetFrame щоб передати його в кеш
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attribute.frame = insetFrame
            cache.append(attribute)

            contentWidth = max(contentWidth, frame.maxX)
            xOffset[row] = xOffset[row] + widht

            //Логіка переходу фото
            row = row < (RowLayout.numbersOfRows - 1) ? (row + 1) : 0
        }

    }

    //Метод буде вираховувати висоту для фото
    static func rowHeightCounter(superViewWidth: CGFloat, photosArray: [CGSize]) -> CGFloat? {
        var rowHeight: CGFloat

        //Шукаємо фото з самим малим співвідношенням сторін
        let photoWidhtMinRatio = photosArray.min { first, second in
            (first.height / first.width) < (second.height / second.width)
        }

        guard let myPhotoWidhtMinRatio = photoWidhtMinRatio else { return nil }

        //Зрівнюємо співвідношення ширини екрана до співвідношення ширини фото найменшого розміру
        let differense = superViewWidth / myPhotoWidhtMinRatio.width

        rowHeight = myPhotoWidhtMinRatio.height * differense
        rowHeight = rowHeight * CGFloat(RowLayout.numbersOfRows)
        return rowHeight
    }

    //MARK: Шаблонний код

    //Представляє інформацію по конкретному елементу
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()

        //Проходимось по атрибутах які знаходяться в кеші
        for attribute in cache {
            if attribute.frame.intersects(rect) {
                visibleLayoutAttributes.append(attribute)
            }
        }
        return visibleLayoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.row]
    }
}
