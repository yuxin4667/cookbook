//
//  writeRecipeScreen.swift
//  component
//
//  Created by dcs on 2024/3/14.
//

import SwiftUI

struct WriteRecipeView: View {
    @Bindable private var recipeFormViewModel: RecipeFormViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @State var foods: [Ingredient] = []
    @State var steps: [String] = []
    @State private var newFood: Ingredient?
    @State private var newStep: String?
    @State private var showPhotoOptions = false
    @State private var addIngredient = false
    @State private var addStep = false
    @State var alertMessage: String = ""
    
    enum PhotoSource: Identifiable {
        case photoLibrary
        case camera

        var id: Int {
            hashValue
        }
    }
    @State private var photoSource: PhotoSource?
    
    init() {
        let viewModel = RecipeFormViewModel()
        viewModel.image = UIImage(named: "plate") ?? UIImage()
        recipeFormViewModel = viewModel
    }
    
    private var isNotValid: Bool {
        recipeFormViewModel.name.isEmpty || recipeFormViewModel.serving == 0 || recipeFormViewModel.time == 0
        || foods.count == 0 || steps.count == 0
    }
    
    private func save() {
        let recipe = Recipe(name: recipeFormViewModel.name, serving: recipeFormViewModel.serving, time: recipeFormViewModel.time, ingredients: foods, step: steps, image: recipeFormViewModel.image, bookMark: recipeFormViewModel.bookMark)
        modelContext.insert(recipe)
    }
    
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack {
                    if (recipeFormViewModel.image==UIImage(named: "plate")) {
                        Image(uiImage: recipeFormViewModel.image)
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: 300)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 15.0))
                            .onTapGesture {
                                self.showPhotoOptions.toggle()
                            }
                            .overlay {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(.systemGray3), lineWidth: 1)
                                    VStack (spacing: 8){
                                        Text("\(Image(systemName: "camera"))")
                                            .font(.system(size: 28))
                                        Text("點擊新增圖片")
                                            .font(.title2)
                                        Text("比例建議 1:1")
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                            }
                            .padding(.bottom, 20)
                    } else {
                        Image(uiImage: recipeFormViewModel.image)
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
                    }
                    
                    
                    
                    FormTextField(label: "食譜名稱", placeholder: "輸入食譜名稱...", value: $recipeFormViewModel.name)
                    
                    FormNumField(label: "份數", placeholder: "", unit: "servings", value: $recipeFormViewModel.serving)
                    
                    FormNumField(label: "時間", placeholder: "", unit: "minutes", value: $recipeFormViewModel.time)
                    
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
                
                    Button {
                        save()
                        dismiss()
                        
                    } label: {
                        Text("完成")
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
                
            }
            .navigationTitle("新增食譜")
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
            case .photoLibrary: ImagePicker(sourceType: .photoLibrary, selectedImage: $recipeFormViewModel.image).ignoresSafeArea()
            case .camera: ImagePicker(sourceType: .camera, selectedImage: $recipeFormViewModel.image).ignoresSafeArea()
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
    }
}

struct FormTextField: View {
    let label: String
    var placeholder: String = ""
    @Binding var value: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color("barTitle"))
            
            TextField(placeholder, text: $value)
                .font(.system(.title2, design: .rounded))
                .multilineTextAlignment(.leading)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(.systemGray3), lineWidth: 1)
                )
                .background(.white)
        }
        .padding(.bottom, 20)
    }
}
struct FormNumField: View {
    let label: String
    var placeholder: String = ""
    var unit: String = ""
    @Binding var value: Int

    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color("barTitle"))
            
            LabeledContent("") {
                HStack {
                    TextField(placeholder, value: $value, format: .number.precision(.fractionLength(0)))
                    Text(unit)
                }
                .font(.system(.title2, design: .rounded))
                .multilineTextAlignment(.leading)
            }
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color(.systemGray3), lineWidth: 1)
            )
            .background(.white)
        }
        .padding(.bottom, 20)
    }
}

