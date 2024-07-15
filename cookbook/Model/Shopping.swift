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
class ItemToBuy {
    var itemRecipe: String = ""
    var itemName: String = ""
    var itemQuantity: String = ""
    var itemLocation: String = ""
    var itemDone: Bool = false
    
    init(itemRecipe: String, itemName: String, itemQuantity: String, itemLocation: String, itemDone: Bool) {
        self.itemRecipe = itemRecipe
        self.itemName = itemName
        self.itemQuantity = itemQuantity
        self.itemLocation = itemLocation
        self.itemDone = itemDone
    }
    
    
}
//struct BuyingItem: Codable, Hashable {
//    var itemName: String
//    var itemQuantity: String
//    var itemLocation: String
//    var done: Bool = false
//}
//struct BuyingItem: Codable, Hashable {
//    var itemName: String = ""
//    var itemQuantity: String = ""
//    var done: Bool = false
//    
//    init(itemName: String, itemQuantity: String, done: Bool) {
//        self.itemName = itemName
//        self.itemQuantity = itemQuantity
//        self.done = done
//    }
//}
//struct BuyingItem: Codable, Hashable {
//    var itemName: String
//    var itemQuantity: String
//    var done: Bool = false
//}
