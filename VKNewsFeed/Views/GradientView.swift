//
//  GradientView.swift
//  VKNewsFeed
//
//  Created by Andriy on 11.08.2022.
//

import UIKit

//Тут реалізуємо градіент view
class GradientView: UIView {
    
    //Кольора градієнта, зробимо так щоб ми могли їх міняти в storyboard
    @IBInspectable private var startCollor: UIColor? {
        didSet {
            setupGradientCollors()
        }
    }
    @IBInspectable private var endCollor: UIColor? {
        didSet {
            setupGradientCollors()
        }
    }
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    //коли працюємо через storeboard то буде працювати цей ініціалізатор
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //Розмір gradientLayer
        gradientLayer.frame = bounds
    }
    
    private func setupGradient() {
        //Додаємо його на екран
        self.layer.addSublayer(gradientLayer)
        setupGradientCollors()
        
        //Задамо звідки початок градіента та де кінець
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
    }
    
    //Задаємо кольора
    private func setupGradientCollors() {
        if let startCollor = startCollor, let endCollor = endCollor {
            gradientLayer.colors = [startCollor.cgColor, endCollor.cgColor]
        }
    }
}
