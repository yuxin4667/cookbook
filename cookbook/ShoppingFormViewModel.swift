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
class ShoppingFormViewModel {
    
    // Input
    var shoppingListName: String = "List"
    var itemName: String = ""
    var itemQuantity: String = ""
    var itemLocation: String = ""
    var itemDone: Bool = false
    //var buyingItem: [BuyingItem] = [BuyingItem(itemName: "", itemQuantity: "", itemLocation: "")]
    init(shoppingListName: String, itemName: String, itemQuantity: String, itemLocation: String, itemDone: Bool) {
        self.shoppingListName = shoppingListName
        self.itemName = itemName
        self.itemQuantity = itemQuantity
        self.itemLocation = itemLocation
        self.itemDone = itemDone
    }
    
//    init(shoppingList: ItemToBuy? = nil) {
//        if let shoppingList = shoppingList {
//            self.shoppingListName = shoppingList.itemRecipe
//            self.buyingItem = shoppingList.buyingItem
//        }
//        
//    }
}

