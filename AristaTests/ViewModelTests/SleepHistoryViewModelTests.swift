//
//  SleepHistoryViewModelTests.swift
//  Arista
//
//  Created by Elo on 28/03/2025.
//


import XCTest
import CoreData
@testable import Arista

class SleepHistoryViewModelTests: CoreDataTestCase {
    
    var userRepository: UserRepository!
    var defaultUser: User!
    
    override func setUp() {
        super.setUp()
        userRepository = UserRepository(context: viewContext)
        do {
            defaultUser = try userRepository.ensureDefaultUserExists()
        } catch {
            XCTFail("Error when creating user: \(error)")
        }
    }
    
    func testFetchSleepDataSuccess() throws {
        let context = viewContext
        
        let sleep1 = Sleep(context: context)
        sleep1.id = UUID()
        sleep1.startDate = Date()
        sleep1.duration = 420
        sleep1.quality = 8
        sleep1.user = defaultUser
        
        let sleep2 = Sleep(context: context)
        sleep2.id = UUID()
        sleep2.startDate = Date().addingTimeInterval(-3600)
        sleep2.duration = 360
        sleep2.quality = 6
        sleep2.user = defaultUser
        
        try context.save()
        
        let sleepRepo = SleepRepository(context: context)
        let viewModel = SleepHistoryViewModel(sleepRepository: sleepRepo)
        
        XCTAssertEqual(viewModel.sleepSessions.count, 2)
        XCTAssertNil(viewModel.error)
    }
    
    func testFetchSleepDataFailure() {
        let failingSleepRepo = FailingSleepRepository(context: viewContext)
        let viewModel = SleepHistoryViewModel(sleepRepository: failingSleepRepo)
        
        XCTAssertNotNil(viewModel.error)
        if case let AppError.repositoryError(message)? = viewModel.error {
            XCTAssertEqual(message, "FailingSleepRepository error")
        } else {
            XCTFail("Expected repositoryError")
        }
    }
}
