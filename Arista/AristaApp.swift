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
    
    var userRepository: UserRepository {
        CoreDataUserRepository(context: persistenceController.container.viewContext)
    }
    
    var exerciseRepository: ExerciseRepository {
        CoreDataExerciseRepository(context: persistenceController.container.viewContext)
    }
    
    var sleepRepository: SleepRepository {
        CoreDataSleepRepository(context: persistenceController.container.viewContext)
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                UserDataView(viewModel: UserDataViewModel(userRepository: userRepository))
                    .tabItem {
                        Label("User", systemImage: "person")
                    }
                ExerciseListView(viewModel: ExerciseListViewModel(exerciseRepository: exerciseRepository))
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .tabItem {
                        Label("Exercises", systemImage: "flame")
                    }
                // Sleep History Screen
                SleepHistoryView(viewModel: SleepHistoryViewModel(sleepRepository: sleepRepository))
                    .tabItem {
                        Label("Sleep", systemImage: "moon.zzz")
                    }
            }
        }
    }
}
