//
//  RecipeListView.swift
//  cookbook
//
//  Created by dcs on 2024/4/20.
//
//github
import SwiftUI
import SwiftData

struct RecipeListView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var searchText = ""
    @State private var searchResult: [Recipe] = []
    @State private var isSearchActive = false
    @State var showWriteRecipeSheet = false
    @State var showEditRecipeSheet = false
    @State var recipeToEdit: Recipe?
    @Query var recipes: [Recipe]
    @State var alignment: TextAlignment = .leading

    private func deleteRecord(indexSet: IndexSet) {
        for index in indexSet {
            let itemToDelete = recipes[index]
            modelContext.delete(itemToDelete)
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                if recipes.count == 0 && isSearchActive == false{
                    Image("whitePicture")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 15.0))
                        .overlay {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color(.systemGray3), lineWidth: 1)
                                VStack (spacing: 8){
                                    Text("\(Image(systemName: "pencil.and.scribble"))")
                                        .font(.system(size: 28))
                                    Text("寫下你的第一篇食譜")
                                        .font(.title2)
                                }
                                .foregroundColor(.gray)
                            }
                        }
                        .onTapGesture {
                            self.showWriteRecipeSheet = true
                        }
                        .listRowBackground(Color("mainBG"))
                        .listRowSeparator(.hidden)
                }
                else {
                    let listItems = isSearchActive ? searchResult : recipes
                    
                    //列出食譜預覽格，有書籤->沒書籤 && 時間先->時間後
                    ForEach(listItems.sorted(by: { $0.bookMark && !$1.bookMark })) { index in
                        ZStack(alignment: .leading) {
                            NavigationLink(destination: RecipeDetailView(recipe: index)) {
                                EmptyView()
                            }
                            .opacity(0)
                            RecipeFrame(recipe: index)
                        }
                        .animation(.default, value: index.bookMark)
                        //編輯食譜：向右滑動
                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            Button {
                                recipeToEdit = index
                                self.showEditRecipeSheet.toggle()
                            } label: {
                                VStack {
                                    Text("編輯")
                                    Image(systemName: "pencil.line")
                                        .imageScale(.large)
                                        .tint(Color(.button))
                                }
                            }
                        }
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .listRowBackground(Color("mainBG"))
                        .edgesIgnoringSafeArea(.all)
                    }
                    //刪除食譜：向左滑動
                    .onDelete(perform: deleteRecord)
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .navigationTitle("My Recipes")
            .navigationBarTitleDisplayMode(.large)
            //新增食譜：右上角＋號
            .toolbar {
                Button(action: {
                    self.showWriteRecipeSheet = true
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.barTitle)
                        .font(.system(size: 20, design: .rounded))
                        .fontWeight(.bold)
                }
            }
            .background(Color("mainBG"))
        }
        //顯示新增食譜表單
        .sheet(isPresented: $showWriteRecipeSheet) {
            WriteRecipeView()
        }
        //顯示編輯食譜表單
        .sheet(item: $recipeToEdit, content: { recipe in
            EditRecipeView(recipe: recipe)
        })
        //顯示搜尋欄
        .searchable(text: $searchText, isPresented: $isSearchActive, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search recipes...")
        //依照食譜名稱搜尋
        .onChange(of: searchText) { oldValue, newValue in
            let predicate = #Predicate<Recipe> { 
                $0.name.localizedStandardContains(newValue)
            }
            let descriptor = FetchDescriptor<Recipe>(predicate: predicate)
        
            if let result = try? modelContext.fetch(descriptor) {
                searchResult = result
            }
        }
        .navigationBarBackButtonHidden(true)
        //印出資料庫路徑(debug用)
        .onAppear {
            debugPrint(URL.applicationSupportDirectory.path(percentEncoded: false))
        }
    }
}

struct RecipeFrame: View {
    @Bindable var recipe: Recipe
    @State var alignment: TextAlignment = .leading

    var body: some View {
        HStack {
            HStack (alignment: .top) {
            
                //縮圖
                Image(uiImage: recipe.image)
                    .resizable()
                    .frame(width: 120, height: 120, alignment: .leading)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                
                VStack(alignment: .leading, spacing: 10) {
                    //名稱
                    Text(recipe.name)
                        .font(.system(.title2, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundColor(.barTitle)
                        .lineLimit(1)
                        .padding(.bottom, 3)
                    //食材tags
                    FlowLayOut(vSpacing: 10, alignment: alignment)() {
                        ForEach(recipe.ingredients, id: \.foodName) { index in
                            Text(index.foodName)
                                .lineLimit(1)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 2)
                                .font(.callout)
                                .foregroundColor(.white)
                                .background(Color("buttonColor"))
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                    }
                    
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 3)
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 30)
        .background(.white)
        //書籤
        .overlay {
            Image(systemName: (recipe.bookMark ? "bookmark.fill" : "bookmark"))
                .padding(.trailing, 5)
                .font(.title)
                .fontWeight(.light)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .foregroundColor(recipe.bookMark ? .yellow : .black)
                .onTapGesture {
                    recipe.bookMark.toggle()
                }
                .animation(.easeInOut, value: recipe.bookMark)
        }
        .padding(.trailing, 2)
    }
}

struct FlowLayOut: Layout {
    var vSpacing: CGFloat = 10
    var alignment: TextAlignment = .leading
    
    struct Row {
        var viewRects: [CGRect] = []
        
        var width: CGFloat { viewRects.last?.maxX ?? 0 }
        var height: CGFloat { viewRects.map(\.height).max() ?? 0 }
        
        func getStartX(in bounds: CGRect, alignment: TextAlignment) -> CGFloat {
            switch alignment {
            case .leading:
                return bounds.minX
            case .center:
                return bounds.minX + (bounds.width - width) / 2
            case .trailing:
                return bounds.maxX - width
            }
        }
    }
    
    
    private func getRows(subviews: Subviews, totalWidth: CGFloat?) -> [Row] {
        guard let totalWidth, !subviews.isEmpty else { return [] }
        
        var rows = [Row()]
        let proposal = ProposedViewSize(width: totalWidth, height: nil)
        
        subviews.enumerated().forEach { index, view in
            let size = view.sizeThatFits(proposal)
            let previousRect = rows.last!.viewRects.last ?? .zero
            let previousView = rows.last!.viewRects.isEmpty ? nil : subviews[index - 1]
            let spacing = previousView?.spacing.distance(to: view.spacing, along: .horizontal) ?? 0
            
            switch previousRect.maxX + spacing + size.width > totalWidth {
            case true:
                let rect = CGRect(origin: .init(x: 0,
                                                y: previousRect.minY + rows.last!.height + vSpacing), size: size)
                rows.append(Row(viewRects: [rect]))
            case false:
                let rect = CGRect(origin: .init(x: previousRect.maxX + spacing,
                                                y: previousRect.minY),
                                  size: size)
                rows[rows.count - 1].viewRects.append(rect)
            }
        }
        
        return rows
    }
    
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = getRows(subviews: subviews, totalWidth: proposal.width)
        
        
        return .init(width: rows.map(\.width).max() ?? 0,
                     height: rows.last?.viewRects.map(\.maxY).max() ?? 0)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let rows = getRows(subviews: subviews, totalWidth: bounds.width)
        var index = 0
        rows.forEach { row in
            let minX = row.getStartX(in: bounds, alignment: alignment)
            
            row.viewRects.forEach { rect in
                let view = subviews[index]
                defer { index += 1 }
                
                view.place(at: .init(x: rect.minX + minX,
                                     y: rect.minY + bounds.minY),
                           proposal: .init(rect.size))
                
            }
        }
    }
}
