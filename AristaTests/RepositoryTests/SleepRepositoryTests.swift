//
//  SleepRepositoryTests.swift
//  Arista
//
//  Created by Elo on 28/03/2025.
//


import XCTest
import CoreData
@testable import Arista

class SleepRepositoryTests: XCTestCase {
    
    var persistentContainer: NSPersistentContainer!
    var sleepRepo: SleepRepository!
    var userRepo: UserRepository!
    let date = Date()
    
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
    
    func testFetchAllSleepSessionsSortedByDateDescending() throws {
        let user = try userRepo.ensureDefaultUserExists()
        let sleepCurrentDate = try sleepRepo.createSleepSession(startDate: date,
                                                                duration: 450,
                                                                quality: 9,
                                                                user: user)
        let sleepPreviousDate = try sleepRepo.createSleepSession(startDate: date.addingTimeInterval(-3600),
                                                                 duration: 450,
                                                                 quality: 9,
                                                                 user: user)
        let sleepNextDate = try sleepRepo.createSleepSession(startDate: date.addingTimeInterval(3600),
                                                             duration: 450,
                                                             quality: 9,
                                                             user: user)
        
        let sleepSessions = try sleepRepo.fetchAllSleepSessions()
        XCTAssertEqual(sleepSessions.count, 3)
        XCTAssertEqual(sleepSessions[0].id, sleepNextDate.id)
        XCTAssertEqual(sleepSessions[1].id, sleepCurrentDate.id)
        XCTAssertEqual(sleepSessions[2].id, sleepPreviousDate.id)
    }
    
    func testDeleteSleepSessionRemovesSession() throws {
        let user = try userRepo.ensureDefaultUserExists()
        let newSleep = try sleepRepo.createSleepSession(startDate: date,
                                                        duration: 450,
                                                        quality: 9,
                                                        user: user)
        var fetchedSessions = try sleepRepo.fetchAllSleepSessions()
        XCTAssertEqual(fetchedSessions.count, 1)
        
        try sleepRepo.deleteSleepSession(newSleep)
        fetchedSessions = try sleepRepo.fetchAllSleepSessions()
        XCTAssertEqual(fetchedSessions.count, 0)
    }
}
