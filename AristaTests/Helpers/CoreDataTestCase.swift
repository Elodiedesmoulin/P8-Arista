//
//  CoreDataTestCase.swift
//  Arista
//
//  Created by Elo on 11/04/2025.
//

import XCTest
import CoreData

@testable import Arista

// MARK: - Base Class for Core Data tests

class CoreDataTestCase: XCTestCase {
    var persistentContainer: NSPersistentContainer!

    override func setUp() {
        super.setUp()
        persistentContainer = PersistenceController(inMemory: true).container
    }

    override func tearDown() {
        persistentContainer = nil
        super.tearDown()
    }
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}
