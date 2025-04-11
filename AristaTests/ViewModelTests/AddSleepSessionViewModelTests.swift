//
//  AddSleepSessionViewModelTests.swift
//  Arista
//
//  Created by Elo on 31/03/2025.
//


import XCTest
import CoreData
@testable import Arista

class AddSleepViewModelTests: CoreDataTestCase {
    
    var sleepRepo: SleepRepository!
    var userRepo: UserRepository!
    
    override func setUp() {
        super.setUp()
        sleepRepo = SleepRepository(context: viewContext)
        userRepo = UserRepository(context: viewContext)
    }
    
    func testAddSleepInvalidDuration() {
        let viewModel = AddSleepViewModel(sleepRepository: sleepRepo, userRepository: userRepo)
        viewModel.duration = "invalid"
        viewModel.quality = "5"
        viewModel.startTime = "01/01/2025 10:00"
        
        let result = viewModel.addSleep()
        XCTAssertFalse(result)
        XCTAssertEqual(viewModel.error, AppError.invalidDuration)
    }
    
    func testAddSleepInvalidQuality() {
        let viewModel = AddSleepViewModel(sleepRepository: sleepRepo, userRepository: userRepo)
        viewModel.duration = "450"
        viewModel.quality = "invalid"
        viewModel.startTime = "01/01/2025 10:00"
        
        let result = viewModel.addSleep()
        XCTAssertFalse(result)
        XCTAssertEqual(viewModel.error, AppError.invalidQuality)
    }
    
    func testAddSleepInvalidStartTime() {
        let viewModel = AddSleepViewModel(sleepRepository: sleepRepo, userRepository: userRepo)
        viewModel.duration = "450"
        viewModel.quality = "8"
        viewModel.startTime = "invalid date"
        
        let result = viewModel.addSleep()
        XCTAssertFalse(result)
        XCTAssertEqual(viewModel.error, AppError.invalidStartTime)
    }
    
    func testAddSleepSuccess() throws {
        _ = try userRepo.ensureDefaultUserExists()
        
        let viewModel = AddSleepViewModel(sleepRepository: sleepRepo, userRepository: userRepo)
        viewModel.duration = "450"
        viewModel.quality = "8"
        viewModel.startTime = "01/01/2025 10:00"
        
        let result = viewModel.addSleep()
        XCTAssertTrue(result)
        XCTAssertNotNil(viewModel.createdSleep)
        XCTAssertEqual(viewModel.createdSleep?.duration, 450)
        XCTAssertEqual(viewModel.createdSleep?.quality, 8)
        
        let expectedDate = DateFormatter.testFormatter.date(from: viewModel.startTime)
        XCTAssertEqual(viewModel.createdSleep?.startDate, expectedDate)
    }
    
    func testAddSleepUserNotFound() {
        let viewModel = AddSleepViewModel(sleepRepository: sleepRepo, userRepository: userRepo)
        viewModel.duration = "450"
        viewModel.quality = "8"
        viewModel.startTime = "01/01/2025 10:00"
        
        let result = viewModel.addSleep()
        XCTAssertFalse(result)
        XCTAssertEqual(viewModel.error, AppError.userNotFound)
    }
    
    func testAddSleepRepositoryError() throws {
        _ = try userRepo.ensureDefaultUserExists()
        let failingSleepRepo = FailingSleepRepository(context: viewContext)
        let viewModel = AddSleepViewModel(sleepRepository: failingSleepRepo, userRepository: userRepo)
        
        viewModel.duration = "50"
        viewModel.quality = "7"
        viewModel.startTime = DateFormatter.testFormatter.string(from: Date())
        
        let result = viewModel.addSleep()
        XCTAssertFalse(result)
        XCTAssertEqual(viewModel.error, AppError.repositoryError("FailingSleepRepository error"))
        XCTAssertNil(viewModel.createdSleep)
    }
}
