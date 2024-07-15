//
//  addContentView.swift
//  DishPicker
//
//  Created by dcs on 2024/4/10.
//

import SwiftUI

struct addIngredientView: View {
    @Binding var foods: [Ingredient]
    @Environment(\.dismiss) var dismiss
    @State private var foodName = ""
    @State private var ingredientWeight = ""

    private func savefood() {
        foods.append(Ingredient(foodName: foodName, quantity: ingredientWeight))
    }
    private var isNotValid: Bool {
        foodName.isEmpty || ingredientWeight.isEmpty
    }
    var body: some View {
        VStack {
            ScrollView {
                Label("新增食材", systemImage: "pencil")
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(Color("barTitle"))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                
                //輸入食材和份量的格子
                LabeledContent("名稱") {
                    TextField("例：雞蛋", text: $foodName)
                        //.font(.system(.title3, design: .rounded))
                        .fontWeight(.regular)
                        .multilineTextAlignment(.trailing)
                }
                .font(.system(.title2, design: .rounded))
                .fontWeight(.light)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(.systemGray3), lineWidth: 1)
                )
                .background(.white)
                .padding(.vertical, 5)
                
                LabeledContent("份量") {
                    TextField("例：1個", text: $ingredientWeight)
                        //.font(.system(.title3, design: .rounded))
                        .fontWeight(.regular)
                        .multilineTextAlignment(.trailing)
                }
                .fontWeight(.light)
                .font(.system(.title2, design: .rounded))
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(.systemGray3), lineWidth: 1)
                )
                .background(.white)
            }
            
            //Add Button
            Button {
                //if foodName != ""{
                    savefood()
                //}
                
                dismiss()
            } label: {
                Text("加入")
                    .frame(maxWidth: .infinity)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(isNotValid ? Color(.systemGray6) : .button)
                    .cornerRadius(15)
                    .foregroundColor(isNotValid ? Color(.systemGray4) : .white)
                    .padding(.vertical, 20)
                    
                
            }
            .disabled(isNotValid)
        }
        
        .padding()
        .background(Color("mainBG"))
    }
    
}
