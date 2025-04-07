//
//  AristaApp.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

@main
struct AristaApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            TabView {
                UserDataView(viewModel: UserDataViewModel(userRepository: UserRepository(context: persistenceController.container.viewContext)))
                    .tabItem {
                        Label("User", systemImage: "person")
                    }
                ExerciseListView(viewModel: ExerciseListViewModel(exerciseRepository: ExerciseRepository(context: persistenceController.container.viewContext)))
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .tabItem {
                        Label("Exercises", systemImage: "flame")
                    }
                SleepHistoryView(viewModel: SleepHistoryViewModel(sleepRepository: SleepRepository(context: persistenceController.container.viewContext)))
                    .environment(\.managedObjectContext, persistenceController.container.viewContext) 
                    .tabItem {
                        Label("Sleep", systemImage: "moon.zzz")
                    }
            }
        }
    }
}
