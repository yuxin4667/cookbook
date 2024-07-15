//
//  cookbookApp.swift
//  cookbook
//
//  Created by dcs on 2024/4/20.
//

import SwiftUI
import SwiftData
import UIKit
@main
struct cookbookApp: App {
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Recipe.self, ItemToBuy.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(for: [Recipe.self, ItemToBuy.self])
    }
    init() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.barTitle, 
            .font: UIFont(name: "ArialRoundedMTBold", size: 38)!]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.barTitle,
            .font: UIFont(name: "ArialRoundedMTBold", size: 24)!]
        navBarAppearance.backgroundColor = .mainBG
        navBarAppearance.backgroundEffect = .none
        navBarAppearance.shadowColor = .none
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
    }
}
