//
//  writeRecipeScreen.swift
//  component
//
//  Created by dcs on 2024/3/14.
//

import SwiftUI

struct EditRecipeView: View {
    @Bindable var recipe: Recipe
    @Environment(\.dismiss) var dismiss
    @State var foods: [Ingredient] = []
    @State var steps: [String] = []
    @State private var newFood: Ingredient?
    @State private var newStep: String?
    @State private var showPhotoOptions = false
    @State private var addIngredient = false
    @State private var addStep = false
    @State private var showAlert = false
    @State var alertMessage: String = ""
    
    enum PhotoSource: Identifiable {
        case photoLibrary
        case camera

        var id: Int {
            hashValue
        }
    }
    @State private var photoSource: PhotoSource?

    private func saveIngredient() {
        recipe.ingredients = foods
    }
   
    private func saveStep() {
        recipe.step = steps
    }
    
    private func showWarning() {
        alertMessage = "請輸入\n"
        showAlert = false
        if recipe.name == "" {
            alertMessage += "食譜名稱 "
            showAlert = true
        }
        if recipe.serving == 0 {
            alertMessage += "食譜份數 "
            showAlert = true
        }
        if recipe.time == 0 {
            alertMessage += "烹調時間 "
            showAlert = true
        }
        if foods.count == 0 {
            alertMessage += "食材 "
            showAlert = true
        }
        if steps.count == 0 {
            alertMessage += "步驟 "
            showAlert = true
        }
    }
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack {
                    Image(uiImage: recipe.image)
                        .resizable()
                        .scaledToFill()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 300)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15.0))
                        .onTapGesture {
                            self.showPhotoOptions.toggle()
                        }
                        .padding(.bottom, 20)
                    
                    
                    
                    FormTextField(label: "食譜名稱", placeholder: "輸入食譜名稱...", value: $recipe.name)
                    
                    FormNumField(label: "份數", placeholder: "", unit: "servings", value: $recipe.serving)
                    
                    FormNumField(label: "時間", placeholder: "", unit: "minutes", value: $recipe.time)
                    
                    VStack {
                        HStack {
                            Text("食材")
                            Button(action: {
                                newFood = Ingredient(foodName: "", quantity: "")
                                addIngredient=true
                            }) {
                                Text("\(Image(systemName: "plus.circle.fill"))")
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        }
                        .font(.title)
                        .fontWeight(.bold)
                        
                        ForEach(0..<foods.count, id: \.self) { index in
                            HStack {
                                Text(foods[index].foodName)
                                    .frame(alignment: .leading)
                                Spacer()
                                Text(foods[index].quantity)
                                Button(action: {
                                    foods.remove(at: index)
                                }) {
                                    Text("\(Image(systemName: "minus.circle.fill"))")
                                        .foregroundColor(Color("buttonColor"))
                                        .font(.title)
                                        .padding(.horizontal, 3)
                                }
                            }
                            .foregroundColor(.black)
                            .font(.title2)
                            .padding(.leading)
                            .padding(.vertical, 5)
                            .background(Color(.white))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .padding(.bottom, 20)
                    .foregroundColor(Color("barTitle"))
                    
                    
                    VStack {
                        HStack {
                            Text("步驟")
                            Button(action: {
                                newStep = ""
                                addStep = true
                            }) {
                                Text("\(Image(systemName: "plus.circle.fill"))")
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        }
                        .font(.title)
                        .fontWeight(.bold)
                        ForEach(0..<steps.count, id: \.self) { key in
                            HStack {
                                Text("\(key+1)")
                                    .font(.title)
                                    .bold()
                                    .foregroundColor(Color("barTitle"))
                                    .padding(.trailing)
                                Text(steps[key])
                                    .font(.title2)
                                    .foregroundColor(.black)
                                    .frame(alignment: .leading)
                                Spacer()
                                Button(action: {
                                    steps.remove(at: key)
                                }) {
                                    Text("\(Image(systemName: "minus.circle.fill"))")
                                        .foregroundColor(Color("buttonColor"))
                                        .font(.title)
                                        .padding(.horizontal, 3)
                                }
                            }
                        }
                        .font(.title2)
                        .padding(.leading)
                        .padding(.vertical, 5)
                        .background(Color(.white))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding(.bottom, 20)
                    .foregroundColor(Color("barTitle"))
                
                    Button(action: {
                        showWarning()
                        if showAlert == false {
                            saveIngredient()
                            saveStep()
                            dismiss()
                        }
                        
                    }) {
                        Text("完成")
                            .frame(maxWidth: .infinity)
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .background(.button)
                            .cornerRadius(15)
                            .foregroundColor(.white)
                            .padding(.vertical, 20)
                    }
                }
                .padding()
                
            }
            .navigationTitle("編輯食譜")
            .background(Color("mainBG"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("\(Image(systemName: "xmark.circle.fill"))")
                            .foregroundColor(Color("barTitle"))
                            .font(.title3)
                    }
                }
            }
        }
        .confirmationDialog("Choose your photo source", isPresented: $showPhotoOptions, titleVisibility: .visible) {
                Button("Camera") {
                    self.photoSource = .camera
                }
                Button("Photo Library") {
                    self.photoSource = .photoLibrary
                }
            }
        .fullScreenCover(item: $photoSource) { source in
            switch source {
            case .photoLibrary: ImagePicker(sourceType: .photoLibrary, selectedImage: $recipe.image).ignoresSafeArea()
            case .camera: ImagePicker(sourceType: .camera, selectedImage: $recipe.image).ignoresSafeArea()
            }
        }
    
        .sheet(isPresented: $addIngredient) {
            addIngredientView(foods: $foods)
                .presentationDetents([.medium, .height(350)])
        }

        .sheet(isPresented: $addStep) {
            addStepView(steps: $steps)
                .presentationDetents([.medium, .height(350)])
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("尚未完成您的食譜"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            foods = recipe.ingredients
            steps = recipe.step
        }
        
    }
}



#Preview {
    EditRecipeView(recipe: Recipe(name: "香菇鑲肉", serving: 3, time: 30, ingredients: [Ingredient(foodName: "香菇", quantity: "7朵"), Ingredient(foodName: "豬絞肉", quantity: "200g"), Ingredient(foodName: "青蔥", quantity: "1支"), Ingredient(foodName: "胡椒粉", quantity: "適量"), Ingredient(foodName: "醬油", quantity: "30ml")], step: ["豬絞肉剁更細，絞肉太粗會影響口感；香菇拔掉梗，梗切成末；蔥花切成末", "將豬絞肉、香菇梗末、蔥花、及所有調味料混合攪拌均勻", "打調和好的肉餡增加黏性", "香菇撒上些許太白粉，作用是讓肉餡巴住香菇，防止在蒸的過程中掉下來，記得香菇邊緣一定要灑到太白粉", "將肉餡用湯匙填入香菇內，接著送進電鍋內，外鍋放入1.5碗水，蒸10~15分鐘"], image: UIImage(named: "香菇鑲肉")!, bookMark: false))
        .modelContainer(for: Recipe.self, inMemory: true)
}

