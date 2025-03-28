//
//  SleepHistoryViewModelTests.swift
//  Arista
//
//  Created by Elo on 28/03/2025.
//


import XCTest
import CoreData
@testable import Arista

class SleepHistoryViewModelTests: XCTestCase {
    
    var persistentContainer: NSPersistentContainer!
    
    override func setUp() {
        super.setUp()
        persistentContainer = CoreDataTestStack.inMemoryPersistentContainer()
    }
    
    override func tearDown() {
        persistentContainer = nil
        super.tearDown()
    }
    
    func testFetchSleepDataSuccess() throws {
        let context = persistentContainer.viewContext

        let user = User(context: context)
        user.firstName = "Dave"
        user.lastName = "Grohl"
        user.email = "dave@example.com"
        user.password = "foo"
        try context.save()
        
        let sleep1 = Sleep(context: context)
        sleep1.id = UUID()
        sleep1.startDate = Date()
        sleep1.duration = 420
        sleep1.quality = 8
        sleep1.user = user
        
        let sleep2 = Sleep(context: context)
        sleep2.id = UUID()
        sleep2.startDate = Date().addingTimeInterval(-3600)
        sleep2.duration = 360
        sleep2.quality = 6
        sleep2.user = user
        
        try context.save()
        
        let sleepRepo = SleepRepository(context: context)
        let viewModel = SleepHistoryViewModel(sleepRepository: sleepRepo)
        
        XCTAssertEqual(viewModel.sleepSessions.count, 2)
        XCTAssertNil(viewModel.error)
    }
    
    func testFetchSleepDataFailure() {
        let failingSleepRepo = FailingSleepRepository(context: persistentContainer.viewContext)
        let viewModel = SleepHistoryViewModel(sleepRepository: failingSleepRepo)
        
        XCTAssertNotNil(viewModel.error)
        if case let AppError.repositoryError(message)? = viewModel.error {
            XCTAssertEqual(message, "FailingSleepRepository error")
        } else {
            XCTFail("Expected repositoryError")
        }
    }
}
