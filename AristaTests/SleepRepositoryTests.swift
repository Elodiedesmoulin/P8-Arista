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
    
    override func setUp() {
        super.setUp()
        persistentContainer = CoreDataTestStack.inMemoryPersistentContainer()
        sleepRepo = SleepRepository(context: persistentContainer.viewContext)
        userRepo = UserRepository(context: persistentContainer.viewContext)
    }
    
    override func tearDown() {
        sleepRepo = nil
        userRepo = nil
        persistentContainer = nil
        super.tearDown()
    }
    
    func testCreateDefaultSleepDataCreatesThreeSessions() throws {
        let user = try userRepo.createDefaultUserIfNeeded()
        // Assure-toi qu'il n'y a pas encore de sessions
        var sessions = try sleepRepo.fetchAllSleepSessions()
        XCTAssertEqual(sessions.count, 0)
        
        try sleepRepo.createDefaultSleepData(for: user)
        sessions = try sleepRepo.fetchAllSleepSessions()
        XCTAssertEqual(sessions.count, 3)
    }
    
    func testFetchAllSleepSessionsSortedByDateDescending() throws {
        let user = try userRepo.createDefaultUserIfNeeded()
        try sleepRepo.createDefaultSleepData(for: user)
        let sessions = try sleepRepo.fetchAllSleepSessions()
        // Vérifie que la session avec la date la plus récente est en premier
        XCTAssertGreaterThan(sessions.first?.startDate ?? Date.distantPast, sessions.last?.startDate ?? Date.distantPast)
    }
    
    func testCreateDefaultSleepDataDoesNotDuplicate() throws {
        let user = try userRepo.createDefaultUserIfNeeded()
        try sleepRepo.createDefaultSleepData(for: user)
        let sessionsFirst = try sleepRepo.fetchAllSleepSessions()
        // Appeler à nouveau la création ne doit pas ajouter de nouvelles sessions
        try sleepRepo.createDefaultSleepData(for: user)
        let sessionsSecond = try sleepRepo.fetchAllSleepSessions()
        XCTAssertEqual(sessionsFirst.count, sessionsSecond.count)
    }
}
