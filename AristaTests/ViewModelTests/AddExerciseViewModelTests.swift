//
//  AddExerciseViewModelTests.swift
//  Arista
//
//  Created by Elo on 28/03/2025.
//


import XCTest
import CoreData
@testable import Arista

class AddExerciseViewModelTests: CoreDataTestCase {
    
    func testAddExerciseSuccess() throws {
        let context = viewContext
        let userRepo = UserRepository(context: context)
        _ = try userRepo.ensureDefaultUserExists()
        
        let exerciseRepo = ExerciseRepository(context: context)
        let viewModel = AddExerciseViewModel(exerciseRepository: exerciseRepo, userRepository: userRepo)
        
        viewModel.selectedCategory = .running
        viewModel.duration = "50"
        viewModel.intensity = "7"
        viewModel.startTime = DateFormatter.testFormatter.string(from: Date())
        
        let result = viewModel.addExercise()
        XCTAssertTrue(result)
        XCTAssertNotNil(viewModel.createdExercise)
        XCTAssertNil(viewModel.error)
    }
    
    func testAddExerciseInvalidDuration() throws {
        let context = viewContext
        let userRepo = UserRepository(context: context)
        let exerciseRepo = ExerciseRepository(context: context)
        let viewModel = AddExerciseViewModel(exerciseRepository: exerciseRepo, userRepository: userRepo)
        
        viewModel.duration = "invalid"
        viewModel.intensity = "7"
        viewModel.startTime = "12/31/2025 12:00"
        
        let result = viewModel.addExercise()
        XCTAssertFalse(result)
        XCTAssertEqual(viewModel.error, AppError.invalidDuration)
        XCTAssertNil(viewModel.createdExercise)
    }
    
    func testAddExerciseInvalidIntensity() throws {
        let context = viewContext
        let userRepo = UserRepository(context: context)
        let exerciseRepo = ExerciseRepository(context: context)
        let viewModel = AddExerciseViewModel(exerciseRepository: exerciseRepo, userRepository: userRepo)
        
        viewModel.duration = "50"
        viewModel.intensity = "invalid"
        viewModel.startTime = "12/31/2025 12:00"
        
        let result = viewModel.addExercise()
        XCTAssertFalse(result)
        XCTAssertEqual(viewModel.error, AppError.invalidIntensity)
        XCTAssertNil(viewModel.createdExercise)
    }
    
    func testAddExerciseInvalidStartTime() throws {
        let context = viewContext
        let userRepo = UserRepository(context: context)
        let exerciseRepo = ExerciseRepository(context: context)
        let viewModel = AddExerciseViewModel(exerciseRepository: exerciseRepo, userRepository: userRepo)
        
        viewModel.duration = "50"
        viewModel.intensity = "7"
        viewModel.startTime = "invalid-date"
        
        let result = viewModel.addExercise()
        XCTAssertFalse(result)
        XCTAssertEqual(viewModel.error, AppError.invalidStartTime)
        XCTAssertNil(viewModel.createdExercise)
    }
    
    func testAddExerciseUserNotFound() throws {
        let context = viewContext
        let failingUserRepo = FailingUserRepository(context: context)
        let exerciseRepo = ExerciseRepository(context: context)
        let viewModel = AddExerciseViewModel(exerciseRepository: exerciseRepo, userRepository: failingUserRepo)
        
        viewModel.duration = "50"
        viewModel.intensity = "7"
        viewModel.startTime = DateFormatter.testFormatter.string(from: Date())
        
        let result = viewModel.addExercise()
        XCTAssertFalse(result)
        XCTAssertEqual(viewModel.error, AppError.repositoryError("FailingUserRepository error"))
        XCTAssertNil(viewModel.createdExercise)
    }
    
    func testAddExerciseRepositoryError() throws {
        let context = viewContext
        let userRepo = UserRepository(context: context)
        _ = try userRepo.ensureDefaultUserExists()
        let failingExerciseRepo = FailingExerciseRepository(context: context)
        let viewModel = AddExerciseViewModel(exerciseRepository: failingExerciseRepo, userRepository: userRepo)
        
        viewModel.duration = "50"
        viewModel.intensity = "7"
        viewModel.startTime = DateFormatter.testFormatter.string(from: Date())
        
        let result = viewModel.addExercise()
        XCTAssertFalse(result)
        XCTAssertEqual(viewModel.error, AppError.repositoryError("FailingExerciseRepository error"))
        XCTAssertNil(viewModel.createdExercise)
    }
}
