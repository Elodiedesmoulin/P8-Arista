//
//  Persistence.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import CoreData
import Foundation

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Arista")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        seedDefaultData()
    }
    
    private func seedDefaultData() {
        let context = container.viewContext
        let userRepo = UserRepository(context: context)
        let sleepRepo = SleepRepository(context: context)
        
        do {
            let user = try userRepo.createDefaultUserIfNeeded()
            try sleepRepo.createDefaultSleepData(for: user)
        } catch {
            print("Seeding error: \(error)")
        }
    }
}
