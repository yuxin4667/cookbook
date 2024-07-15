//
//  DishFormViewModel.swift
//  component
//
//  Created by dcs on 2024/3/16.
//

import Foundation
import Combine
import SwiftUI

@Observable
class RecipeFormViewModel {
    
    // Input
    
    var name: String = ""
    var serving: Int = 0
    var time: Int = 0
    var ingredients: [Ingredient] = [Ingredient(foodName: "", quantity: "")]
    var step: [String] = [""]
    var image: UIImage = UIImage()
    var bookMark: Bool = false
    
    init(recipe: Recipe? = nil) {
        
        if let recipe = recipe {
            self.name = recipe.name
            self.serving = recipe.serving
            self.time = recipe.time
            self.ingredients = recipe.ingredients
            self.step = recipe.step
            self.image = recipe.image
            self.bookMark = recipe.bookMark
        }
        
    }
}

