//
//  CoreDataTestStack.swift
//  Arista
//
//  Created by Elo on 28/03/2025.
//


import CoreData
import XCTest

class CoreDataTestStack {
    static func inMemoryPersistentContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "Arista")
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (_, error) in
            XCTAssertNil(error, "Failed to load in-memory persistent stores: \(error?.localizedDescription ?? "unknown error")")
        }
        return container
    }
}