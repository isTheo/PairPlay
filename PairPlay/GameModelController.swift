//
//  GameModelController.swift
//  PairPlay
//
//  Created by Matteo Orru on 09/12/24.
//

import UIKit


class GameModelController {
    var cardImages: [UIImage] = []
    private var level1Images = ["burger", "burrito", "nigiri", "pizza"]
    private var level2Images = ["burger", "burrito", "nigiri", "pizza", "milkshake", "fries"]
    private var level3Images = ["burger", "burrito", "nigiri", "pizza", "milkshake", "fries", "apple", "banana"]
    
    init(level: Int) {
        setupImages(for: level)
    }
    
    
    private func setupImages(for level: Int) {
        var images: [UIImage] = []
        let imageNames = switch level {
            case 1: level1Images
            case 2: level2Images
            case 3: level3Images
            default: level1Images
        }
        
        for name in imageNames {
            if let image = UIImage(named: name) {
                images.append(image)
                images.append(image)
            }
        }
        images.shuffle()
        cardImages = images
    }
    
    
    func isMatch(firstIndex: Int, secondIndex: Int) -> Bool {
        return cardImages[firstIndex] == cardImages[secondIndex]
    }
    
    
    
}
