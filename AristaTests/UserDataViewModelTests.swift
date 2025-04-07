//
//  UserDataViewModelTests.swift
//  AristaTests
//
//  Created by Elo on 28/03/2025.
//

import XCTest
import CoreData
@testable import Arista

class UserDataViewModelTests: XCTestCase {
    
    var persistentContainer: NSPersistentContainer!
    
    override func setUp() {
        super.setUp()
        persistentContainer = PersistenceController(inMemory: true).container
    }
    
    override func tearDown() {
        persistentContainer = nil
        super.tearDown()
    }
    
    func testFetchUserSuccess() throws {
        let context = persistentContainer.viewContext
        let user = User(context: context)
        user.firstName = "Alice"
        user.lastName = "Wonderland"
        user.email = "alice@example.com"
        user.password = "secret"
        try context.save()
        
        let userRepo = UserRepository(context: context)
        let viewModel = UserDataViewModel(userRepository: userRepo)
        
        XCTAssertEqual(viewModel.firstName, "Alice")
        XCTAssertEqual(viewModel.lastName, "Wonderland")
        XCTAssertEqual(viewModel.email, "alice@example.com")
        XCTAssertEqual(viewModel.password, "secret")
        XCTAssertNil(viewModel.error)
    }
    
    func testFetchUserFailure() {
        let failingUserRepo = FailingUserRepository(context: persistentContainer.viewContext)
        let viewModel = UserDataViewModel(userRepository: failingUserRepo)
        
        XCTAssertNotNil(viewModel.error)
        if case let AppError.repositoryError(message)? = viewModel.error {
            XCTAssertEqual(message, "FailingUserRepository error")
        } else {
            XCTFail("Expected repositoryError")
        }
    }
}
