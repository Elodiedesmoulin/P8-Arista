//
//  CoreDataUserRepositoryTests.swift
//  AristaTests
//
//  Created by Elo on 26/03/2025.
//

import XCTest
import CoreData
@testable import Arista

class UserRepositoryTests: XCTestCase {
    
    var userRepo: UserRepository!
    
    override func setUp() {
        super.setUp()
        let persistentContainer = PersistenceController(inMemory: true).container
        userRepo = UserRepository(context: persistentContainer.viewContext)
    }
    
    override func tearDown() {
        userRepo = nil
        super.tearDown()
    }
    
    func testCreateDefaultUserIfNeededCreatesUser() throws {
        let user = try userRepo.ensureDefaultUserExists()
        XCTAssertNotNil(user)
        XCTAssertEqual(user.firstName, "John")
        XCTAssertEqual(user.lastName, "Smith")
        XCTAssertEqual(user.email, "john.smith@example.com")
        XCTAssertEqual(user.password, "1234")
    }
    
    func testFetchSingleUserReturnsUser() throws {
        let createdUser = try userRepo.ensureDefaultUserExists()

        let fetchedUser = try userRepo.fetchSingleUser()
        XCTAssertNotNil(fetchedUser)
        XCTAssertEqual(createdUser.objectID, fetchedUser?.objectID)
    }
    
    func testCreateDefaultUserIfNeededReturnsSameUserOnSubsequentCalls() throws {
        let user1 = try userRepo.ensureDefaultUserExists()

        let user2 = try userRepo.ensureDefaultUserExists()
        XCTAssertEqual(user1.objectID, user2.objectID)
    }
}
