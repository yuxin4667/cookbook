//
//  ShoppingListView.swift
//  cookbook
//
//  Created by dcs on 2024/5/2.
//

import SwiftUI
import SwiftData

struct ShoppingListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @Query var shoppingList: [ItemToBuy]
    //長按食譜名稱
    @State private var editListQuestion = false
    @State private var addItemQuestion = false
    @State private var showEditListNameAlert = false
    @State private var selectedCategory: String? = nil //刪除清單的清單名稱
    //紀錄食譜名稱之輸入
    @State private var newListName: String = ""
    //食材右側...
    @State private var selectedItemIndex: Int? //選擇哪項食材
    @State private var showEditItemQuestion = false
    @State private var showEditQuantityAlert = false
    @State private var showEditLocationAlert = false
    //紀錄食材右側...之輸入
    @State private var newName: String = ""
    @State private var newQuantity: String = ""
    @State private var newLocation: String = ""
    //Picker
    @State var selectedOrder = "依食譜"
    let order = ["依食譜", "依地點"]
    //分類後列出
    @State var groupedItems = [String: [ItemToBuy]]()
    //＋號：新增空清單
    @State private var showCreateListNameAlert = false
    @State private var createEmptyListName: String = ""
    let unDefineLocation = "未設定地點"
    let unDefineRecipe = "未設定食譜"
    
    private func reSortDic() {
        if selectedOrder == "依食譜" {
            sortByItemRecipe()
        }
        else if selectedOrder == "依地點" {
            sortByItemLocation()
        }
    }
    
    private func deleteRecord(indexSet: IndexSet) {
        for index in indexSet {
            let itemToDelete = shoppingList[index]
            modelContext.delete(itemToDelete)
        }
    }
    
    private func deleteList(category: String) {
        if selectedOrder == "依食譜" {
            if let itemsToDelete = groupedItems[category] {
                for item in itemsToDelete {
                    modelContext.delete(item)
                }
                groupedItems[category] = nil
            }
        }
        else if selectedOrder == "依地點" {
            for item in shoppingList where item.itemLocation == category {
                modelContext.delete(item)
            }
            groupedItems[category] = nil
        }
    }
    
    private func sortByItemRecipe() {
        groupedItems = [:] // 初始化 groupedItems 為空字典
            
        for item in shoppingList {
            if groupedItems[item.itemRecipe] == nil {
                groupedItems[item.itemRecipe] = [] // 如果鍵不存在，初始化空陣列
            }
            groupedItems[item.itemRecipe]?.append(item) // 將項目添加到對應的食譜名稱鍵的陣列中
        }
    }
    
    private func sortByItemLocation() {
        groupedItems = [:] // 初始化 groupedItems 為空字典
            
        for item in shoppingList {
            if groupedItems[item.itemLocation] == nil {
                groupedItems[item.itemLocation] = [] // 如果鍵不存在，初始化空陣列
            }
            groupedItems[item.itemLocation]?.append(item) // 將項目添加到對應的食譜名稱鍵的陣列中
        }
    }

    
    var body: some View {
        NavigationStack {
            VStack {
                if shoppingList.count == 0 {
                    VStack {
                        Button {
                            self.showCreateListNameAlert.toggle()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color(.systemGray3), lineWidth: 1)
                                VStack (spacing: 8){
                                    Text("\(Image(systemName: "pencil.and.scribble"))")
                                        .font(.system(size: 28))
                                    Text("新增你的第一個清單")
                                        .font(.title2)
                                }
                                .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, maxHeight: 200)
                            .background(.white)
                            .padding()
                        }
                        Spacer()
                    }
                    .listRowBackground(Color("mainBG"))
                    .listRowSeparator(.hidden)
                    .background(Color("mainBG"))
                }
                else {
                    Picker("aaa", selection: $selectedOrder) {
                        ForEach(order, id: \.self) {
                            Text($0)
                                .font(.title3)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    .onChange(of: selectedOrder) {
                        reSortDic()
                    }
                    
                    if selectedOrder == "依食譜" {
                        List {
                            ForEach(groupedItems.sorted(by: { $0.key < $1.key }), id: \.key) { recipe, items in
                                VStack {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 0.0)
                                            .foregroundColor(.white)
                                        
                                        (Text(Image(systemName: "list.bullet.clipboard"))+Text(recipe))
                                            .font(.system(.title2, design: .rounded))
                                            .fontWeight(.semibold)
                                            .foregroundColor(.barTitle)
                                            .lineLimit(1)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .font(.system(.title2, design: .rounded))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.barTitle)
                                    .lineLimit(1)
                                    .padding(.vertical, 8)
                                    .ignoresSafeArea()
                                    .simultaneousGesture(LongPressGesture().onChanged { _ in
                                        print("Taaap started"+recipe)
                                    })
                                    .simultaneousGesture(LongPressGesture().onEnded { _ in
                                        newName = ""
                                        newQuantity = ""
                                        newListName = ""
                                        editListQuestion.toggle()
                                        selectedCategory = recipe
                                        print("Taaap ended"+(selectedCategory ?? "null"))
                                    })
                                    .confirmationDialog(selectedCategory ?? "", isPresented: $editListQuestion) {
                                        Button("新增商品") {
                                            self.addItemQuestion.toggle()
                                        }
                                        Button("變更名稱") {
                                            self.showEditListNameAlert.toggle()
                                        }
                                        Button("刪除\(selectedCategory ?? "")") {
                                            if let recipeToDelete = selectedCategory {
                                                print("刪除清單：\(recipeToDelete)")
                                                deleteList(category: recipeToDelete)
                                            }
                                        }
                                    }
                                    .alert("增加至購物清單", isPresented: $addItemQuestion) {
                                        TextField("商品名稱", text: $newName)
                                            .font(.title3)
                                        TextField("商品份量", text: $newQuantity)
                                            .font(.title3)
                        
                                        Button("取消") {
                                            dismiss()
                                        }
                                        Button("確定") {
                                            if let addAnItem = selectedCategory {
                                                print("增加至購物清單：\(addAnItem)")
                                                modelContext.insert(ItemToBuy(itemRecipe: selectedCategory ?? unDefineRecipe, itemName: newName, itemQuantity: newQuantity, itemLocation: unDefineLocation, itemDone: false))
                                            }
                                            
                                        }
                                    }
                                    .alert("變更清單名稱", isPresented: $showEditListNameAlert) {
                                        TextField("清單名稱", text: $newListName)
                                            .font(.title3)
                        
                                        Button("取消") {
                                            dismiss()
                                        }
                                        Button("確定") {
                                            for i in shoppingList {
                                                if i.itemRecipe == selectedCategory {
                                                    i.itemRecipe = newListName
                                                }
                                            }
                                            reSortDic()
                                        }
                                    }
                                    ForEach(items.sorted(by: { !$0.itemDone && $1.itemDone })) { item in
                                        if item.itemName != "" {
                                            Divider()
                                            RecipeListFrame(itemToBuy: item)
                                        }
                                    }
                                    .onDelete(perform: deleteRecord)
                                }
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .listRowBackground(Color("mainBG"))
                                .edgesIgnoringSafeArea(.all)
                        }
                            .onChange(of: shoppingList) {
                                reSortDic()
                            }
                        .listRowBackground(Color("mainBG"))
                        .listRowSeparator(.hidden)
                        .background(Color("mainBG"))
                    }
                        .listStyle(.plain)
                        
                    }
                    else if selectedOrder == "依地點" {
                        List {
                            ForEach(groupedItems.sorted(by: { $0.key < $1.key }), id: \.key) { location, items in
                                VStack {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 0.0)
                                            .foregroundColor(.white)
                                        
                                        (Text(Image(systemName: "mappin.and.ellipse"))+Text(location))
                                            .font(.system(.title2, design: .rounded))
                                            .fontWeight(.semibold)
                                            .foregroundColor(.barTitle)
                                            .lineLimit(1)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .font(.system(.title2, design: .rounded))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.barTitle)
                                    .lineLimit(1)
                                    .padding(.vertical, 8)
                                    .ignoresSafeArea()
                                    .simultaneousGesture(LongPressGesture().onChanged { _ in
                                        print("Taaap started"+location)
                                    })
                                    .simultaneousGesture(LongPressGesture().onEnded { _ in
                                        newName = ""
                                        newQuantity = ""
                                        newListName = ""
                                        editListQuestion.toggle()
                                        selectedCategory = location
                                        print("Taaap ended"+(selectedCategory ?? "null"))
                                    })
                                    .confirmationDialog("", isPresented: $editListQuestion) {
                                        Button("新增商品") {
                                            self.addItemQuestion.toggle()
                                        }
                                        Button("變更名稱") {
                                            self.showEditListNameAlert.toggle()
                                        }
                                        Button("刪除\(selectedCategory ?? "")") {
                                            if let locationToDelete = selectedCategory {
                                                print("刪除清單：\(locationToDelete)")
                                                deleteList(category: locationToDelete)
                                            }
                                        }
                                    }
                                    .alert("增加至購物清單", isPresented: $addItemQuestion) {
                                        TextField("商品名稱", text: $newName)
                                            .font(.title3)
                                        TextField("商品份量", text: $newQuantity)
                                            .font(.title3)
                                        
                                        Button("取消") {
                                            dismiss()
                                        }
                                        Button("確定") {
                                            if let addAnItem = selectedCategory {
                                                print("增加至購物清單：\(addAnItem)")
                                                modelContext.insert(ItemToBuy(itemRecipe: unDefineRecipe, itemName: newName, itemQuantity: newQuantity, itemLocation: selectedCategory ?? "null", itemDone: false))
                                            }
                                        }
                                    }
                                    .alert("變更清單名稱", isPresented: $showEditListNameAlert) {
                                        TextField("清單名稱", text: $newListName)
                                            .font(.title3)
                                        
                                        Button("取消") {
                                            dismiss()
                                        }
                                        Button("確定") {
                                            for i in shoppingList {
                                                if i.itemLocation == selectedCategory {
                                                    i.itemLocation = newListName
                                                }
                                            }
                                            reSortDic()
                                        }
                                    }
                                    ForEach(items.sorted(by: { !$0.itemDone && $1.itemDone })) { item in
                                        if item.itemName != "" {
                                            Divider()
                                            LocationListFrame(itemToBuy: item)
                                        }
                                    }
                                    .onDelete(perform: deleteRecord)
                                }
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .listRowBackground(Color("mainBG"))
                                .edgesIgnoringSafeArea(.all)
                            }
                            .onChange(of: shoppingList) {
                                reSortDic()
                            }
                            .listRowBackground(Color("mainBG"))
                            .listRowSeparator(.hidden)
                            .background(Color("mainBG"))
                        }
                        .listStyle(.plain)
                    }
                }
            }
            .onAppear() {
                reSortDic()
            }
            .alert("建立清單", isPresented: $showCreateListNameAlert) {
                TextField("清單名稱", text: $createEmptyListName)
                    .font(.title3)

                Button("取消") {
                    dismiss()
                }
                Button("確定") {
                    if selectedOrder == "依食譜" {
                        modelContext.insert(ItemToBuy(itemRecipe: createEmptyListName, itemName: "", itemQuantity: "", itemLocation: unDefineLocation, itemDone: false))
                    }
                    else if selectedOrder == "依地點" {
                        modelContext.insert(ItemToBuy(itemRecipe: unDefineRecipe, itemName: "", itemQuantity: "", itemLocation: createEmptyListName, itemDone: false))
                    }
                }
            }
            .navigationTitle("Shopping List")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                Button(action: {
                    self.showCreateListNameAlert.toggle()
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.barTitle)
                        .font(.system(size: 20, design: .rounded))
                        .fontWeight(.bold)
                }
            }
            .background(Color("mainBG"))
        }
        .background(Color("mainBG"))
    }
}

struct RecipeListFrame: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var itemToBuy: ItemToBuy
    @Environment(\.dismiss) var dismiss
    @State private var showEditItemQuestion = false
    @State private var addItemQuestion = false
    @State private var editListQuestion = false
    @State private var showEditQuantityAlert = false
    @State private var showEditLocationAlert = false
    @State private var showEditListNameAlert = false
    @State private var newName: String = ""
    @State private var newQuantity: String = ""
    @State private var newLocation: String = ""
    let unDefineLocation = "未設定地點"
    private var isNotValid: Bool {
        itemToBuy.itemDone == true
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: itemToBuy.itemDone ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(Color(.systemGray))
                    .onTapGesture {
                        self.itemToBuy.itemDone.toggle()
                    }
                VStack (alignment: .leading) {
                    HStack {
                        Text(itemToBuy.itemName+" ")
                            .foregroundColor(isNotValid ? Color(.systemGray2) : .black)
                        Text(itemToBuy.itemQuantity)
                            .foregroundColor(isNotValid ? Color(.systemGray3) : .gray)
                    }
                    .font(.system(.title3, design: .rounded))
                    if itemToBuy.itemLocation != unDefineLocation {
                        HStack {
                        Image(systemName: "mappin.and.ellipse")
                            Text(itemToBuy.itemLocation)
                        }
                        .font(.callout)
                        .foregroundStyle(.button)
                    }
                }
                Spacer()
                
                Image(systemName: "ellipsis")
                    .frame(width: 50, height: 50)
                    .onTapGesture {
                        self.showEditItemQuestion.toggle()
                        newQuantity = ""
                        newLocation = ""
                    }
                    .foregroundColor(isNotValid ? Color(.systemGray3) : .gray)
                    .disabled(isNotValid)
            }
            .font(.title2)
            .padding(.vertical, 8)
        }
        .font(.title2)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 15)
        .background(.white)

        //選擇要編輯份量or編輯分類
        .confirmationDialog(itemToBuy.itemName+" "+itemToBuy.itemQuantity,
                            isPresented: $showEditItemQuestion,
                            titleVisibility: .visible
        ) {
            Button("編輯份量") {
                // 在這裡處理編輯份量的操作
                self.showEditQuantityAlert.toggle()
            }
            Button("編輯地點") {
                // 在這裡處理編輯地點的操作
                self.showEditLocationAlert.toggle()
            }
            Button("刪除商品") {
                modelContext.delete(itemToBuy)
            }
        }
        //編輯份量的alert
        .alert("\(itemToBuy.itemName) 的份量",
               isPresented: $showEditQuantityAlert) {
            
            TextField(itemToBuy.itemQuantity, text: $newQuantity)
            
            Button("取消") {
                dismiss()
            }
            Button("確定") {
                self.itemToBuy.itemQuantity = newQuantity
            }
        }
        //編輯地點的alert
        .alert("買 \(itemToBuy.itemName) 的地點", isPresented: $showEditLocationAlert)
        {
            TextField(itemToBuy.itemLocation, text: $newLocation)
            Button("取消") {
                dismiss()
            }
            Button("確定") {
                self.itemToBuy.itemLocation = newLocation
            }
       }
    }
}

struct LocationListFrame: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var itemToBuy: ItemToBuy
    @Environment(\.dismiss) var dismiss
    @State private var showEditItemQuestion = false
    @State private var addItemQuestion = false
    @State private var editListQuestion = false
    @State private var showEditQuantityAlert = false
    @State private var showEditListNameAlert = false
    @State private var newName: String = ""
    @State private var newQuantity: String = ""
    let unDefineRecipe = "未設定食譜"
    private var isNotValid: Bool {
        itemToBuy.itemDone == true
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: itemToBuy.itemDone ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(.gray)
                    .onTapGesture {
                        self.itemToBuy.itemDone.toggle()
                    }
                VStack (alignment: .leading) {
                    HStack {
                        Text(itemToBuy.itemName+" ")
                            .foregroundColor(isNotValid ? Color(.systemGray2) : .black)
                        Text(itemToBuy.itemQuantity)
                            .foregroundColor(isNotValid ? Color(.systemGray3) : .gray)
                    }
                    .font(.system(.title3, design: .rounded))
                    if itemToBuy.itemRecipe != unDefineRecipe {
                        HStack {
                            Image(systemName: "list.bullet.clipboard")
                            Text(itemToBuy.itemRecipe)
                        }
                        .font(.callout)
                        .foregroundStyle(.button)
                    }
                }
                Spacer()
                Image(systemName: "ellipsis")
                    .frame(width: 50, height: 50)
                    .onTapGesture {
                        self.showEditItemQuestion.toggle()
                        newQuantity = ""
                    }
                    .foregroundColor(isNotValid ? Color(.systemGray3) : .gray)
                    .disabled(isNotValid)
            }
            .font(.title2)
            .padding(.vertical, 8)
        }
        .font(.title2)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 15)
        .background(.white)

        //選擇要編輯份量or編輯分類
        .confirmationDialog(itemToBuy.itemName+" "+itemToBuy.itemQuantity,
                            isPresented: $showEditItemQuestion,
                            titleVisibility: .visible
        ) {
            Button("編輯份量") {
                // 在這裡處理編輯份量的操作
                self.showEditQuantityAlert.toggle()
            }
            Button("刪除商品") {
                modelContext.delete(itemToBuy)
            }
        }
        //編輯份量的alert
        .alert("\(itemToBuy.itemName) 的份量",
               isPresented: $showEditQuantityAlert) {
            
            TextField(itemToBuy.itemQuantity, text: $newQuantity)
            
            Button("取消") {
                dismiss()
            }
            Button("確定") {
                self.itemToBuy.itemQuantity = newQuantity
            }
        }
    }
}
