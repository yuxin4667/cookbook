//
//  MainView.swift
//  cookbook
//
//  Created by dcs on 2024/6/20.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTabIndex = 0
    var body: some View {
        TabView(selection: $selectedTabIndex) {
            RecipeListView()
                .tabItem {
                    Label("My Recipes", systemImage: "book.circle")
                }
                .tag(0)
            
            ShoppingListView()
                .tabItem { Label("My Shopping List", systemImage: "cart.circle.fill") }
                .tag(1)
        }
        .tint(.button)
    }
}

#Preview {
    MainView()
}
