//
//  Recipe.swift
//  cookbook
//
//  Created by dcs on 2024/4/20.
//

import Foundation
import SwiftUI
import SwiftData

@Model 
class Recipe {
    var name: String = ""
    //var image: String = ""
    var serving: Int = 0
    var time: Int = 0
    var ingredients: [Ingredient] = [Ingredient(foodName: "", quantity: "")]
    var step: [String] = [""]
    var bookMark: Bool = false
    
    @Attribute(.externalStorage) var imageData = Data()
        
    @Transient var image: UIImage {
        get {
            UIImage(data: imageData) ?? UIImage()
        }
        set {
            self.imageData = newValue.pngData() ?? Data()
        }
    }
    
    
    init(name: String, serving: Int, time: Int, ingredients: [Ingredient], step: [String], image: UIImage = UIImage(), bookMark: Bool) {
        self.name = name
        self.serving = serving
        self.time = time
        self.ingredients = ingredients
        self.step = step
        self.image = image
        self.bookMark = bookMark
    }
    
    
}

struct Ingredient: Codable, Hashable {
    var foodName: String
    var quantity: String
}
