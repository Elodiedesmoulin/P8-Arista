//
//  AddSleepSessionViewModelTests.swift
//  Arista
//
//  Created by Elo on 31/03/2025.
//


import XCTest
import CoreData
@testable import Arista


class AddSleepViewModelTests: XCTestCase {

    var persistentContainer: NSPersistentContainer!
    var sleepRepo: SleepRepository!
    var userRepo: UserRepository!
    
    override func setUp() {
        super.setUp()
        persistentContainer = PersistenceController(inMemory: true).container
        sleepRepo = SleepRepository(context: persistentContainer.viewContext)
        userRepo = UserRepository(context: persistentContainer.viewContext)
    }
    
    override func tearDown() {
        sleepRepo = nil
        userRepo = nil
        persistentContainer = nil
        super.tearDown()
    }
    
    func testAddSleepInvalidDuration() {
        let viewModel = AddSleepSessionViewModel(sleepRepository: sleepRepo, userRepository: userRepo)
        viewModel.duration = "invalid"
        viewModel.quality = "5"
        viewModel.startTime = "01/01/2025 10:00"
        
        let result = viewModel.addSleep()
        XCTAssertFalse(result)
        XCTAssertEqual(viewModel.error, AppError.invalidDuration)
    }
    
    func testAddSleepInvalidQuality() {
        let viewModel = AddSleepSessionViewModel(sleepRepository: sleepRepo, userRepository: userRepo)
        viewModel.duration = "450"
        viewModel.quality = "invalid"
        viewModel.startTime = "01/01/2025 10:00"
        
        let result = viewModel.addSleep()
        XCTAssertFalse(result)
        XCTAssertEqual(viewModel.error, AppError.invalidQuality)
    }
    
    func testAddSleepInvalidStartTime() {
        let viewModel = AddSleepSessionViewModel(sleepRepository: sleepRepo, userRepository: userRepo)
        viewModel.duration = "450"
        viewModel.quality = "8"
        viewModel.startTime = "invalid date"
        
        let result = viewModel.addSleep()
        XCTAssertFalse(result)
        XCTAssertEqual(viewModel.error, AppError.invalidStartTime)
    }
    
    func testAddSleepUserNotFound() {
        let viewModel = AddSleepSessionViewModel(sleepRepository: sleepRepo, userRepository: userRepo)
        viewModel.duration = "450"
        viewModel.quality = "8"
        viewModel.startTime = "01/01/2025 10:00"
        
        let result = viewModel.addSleep()
        XCTAssertFalse(result)
        XCTAssertEqual(viewModel.error, AppError.userNotFound)
    }
    
    func testAddSleepSuccess() throws {
        let _ = try userRepo.createDefaultUserIfNeeded()
        
        let viewModel = AddSleepSessionViewModel(sleepRepository: sleepRepo, userRepository: userRepo)
        viewModel.duration = "450"
        viewModel.quality = "8"
        viewModel.startTime = "01/01/2025 10:00"
        
        let result = viewModel.addSleep()
        XCTAssertTrue(result)
        XCTAssertNotNil(viewModel.createdSleep)
        XCTAssertEqual(viewModel.createdSleep?.duration, 450)
        XCTAssertEqual(viewModel.createdSleep?.quality, 8)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm"
        let expectedDate = formatter.date(from: "01/01/2025 10:00")
        XCTAssertEqual(viewModel.createdSleep?.startDate, expectedDate)
    }
    
    
    func testAddSleepRepositoryError() throws {
        _ = try userRepo.createDefaultUserIfNeeded()
        let failingSleepRepo = FailingSleepRepository(context: persistentContainer.viewContext)
        let viewModel = AddSleepSessionViewModel(sleepRepository: failingSleepRepo, userRepository: userRepo)
        
        viewModel.duration = "50"
        viewModel.quality = "7"
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm"
        viewModel.startTime = formatter.string(from: Date())
        
        let result = viewModel.addSleep()
        XCTAssertFalse(result)
        XCTAssertEqual(viewModel.error, AppError.repositoryError("FailingSleepRepository error"))
        XCTAssertNil(viewModel.createdSleep)
    }
}
