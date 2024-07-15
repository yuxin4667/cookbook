//
//  DishDetailView.swift
//  DishPicker
//
//  Created by dcs on 2024/4/6.
//

import SwiftUI
import SwiftData
struct RecipeDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    var recipe: Recipe
    @State private var addToShoppingListAlert = false
    @Query var shoppingList: [ItemToBuy]
    let unDefineLocation = "未設定地點"
    
    var body: some View {
        VStack {
            ScrollView {
                
                Image(uiImage: recipe.image)
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 420)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                
                Text(recipe.name)
                    .font(.system(size: 32, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(Color("barTitle"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                
                HStack(alignment: .top){
                    VStack{
                        Image(systemName: "frying.pan")
                        Text(recipe.serving.formatted())
                            .font(.system(size: 24, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(Color("barTitle"))
                        Text("serving")
                    }

                    Divider().frame(width:1).padding(.horizontal)
                    
                    VStack{
                        Image(systemName: "hourglass") //clock
                        Text(recipe.time.formatted())
                            .font(.system(size: 24, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(Color("barTitle"))
                        Text("minutes")
                    }
                }
                .font(.system(size: 18, design: .rounded))
                .frame(maxWidth: .infinity)
                .padding()
                .padding(.horizontal)
                .foregroundColor(.gray)
                .background(RoundedRectangle(cornerRadius: 8).foregroundColor(Color("mainBG")))
                

                VStack(spacing: 8) {
                    
                    HStack {
                        Text("食材")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color("barTitle"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 5)
                        Button {
                            for index in 0..<recipe.ingredients.count { //食譜中每樣食材
                                let itemToBuy = ItemToBuy(itemRecipe: recipe.name, itemName: recipe.ingredients[index].foodName, itemQuantity: recipe.ingredients[index].quantity, itemLocation: unDefineLocation, itemDone: false)
                                modelContext.insert(itemToBuy)
                            }
                            let itemToBuy = ItemToBuy(itemRecipe: recipe.name, itemName: "", itemQuantity: "", itemLocation: unDefineLocation, itemDone: false)
                            modelContext.insert(itemToBuy)
                            self.addToShoppingListAlert.toggle()
                        } label: {
                            (Text("\(Image(systemName: "plus.circle.fill"))")+Text("加入採買清單"))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    
                    ForEach(0..<recipe.ingredients.count, id: \.self) { index in
                        HStack {
                            Text(recipe.ingredients[index].foodName)
                                .frame(alignment: .leading)
                            Spacer()
                            Text(recipe.ingredients[index].quantity)
                        }
                        .font(.title2)
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                        .background(Color(.white))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding(.horizontal)
                
                Spacer()

                VStack {
                    Text("步驟")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color("barTitle"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 15)
                        .padding(.bottom, 5)
                    
                        ForEach(0..<recipe.step.count, id: \.self) { key in
                            HStack {
                                Text("\(key+1)")
                                    .font(.title)
                                    .bold()
                                    .foregroundColor(Color("barTitle"))
                                    .padding(.trailing)
                                Text(recipe.step[key])
                                    .font(.title2)
                                    .frame(alignment: .leading)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                        .background(Color(.white))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.horizontal)
                .padding(.bottom, 15)
            }
            .padding(.horizontal, 5)
        }
//        .confirmationDialog("已加入至採買清單", isPresented: $addToShoppingListAlert) {
//            Button("查看清單") {
//                ShoppingListView()
//            }
//        }
        .background(Color("mainBG"))
        .navigationBarTitleDisplayMode(.inline)
    }
}





