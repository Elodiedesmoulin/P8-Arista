//
//  ExerciseListViewModelTests.swift
//  Arista
//
//  Created by Elo on 28/03/2025.
//


import XCTest
import CoreData
@testable import Arista

class ExerciseListViewModelTests: CoreDataTestCase {
    
    var userRepository: UserRepository!
    var defaultUser: User!
    
    override func setUp() {
        super.setUp()
        userRepository = UserRepository(context: viewContext)
        do {
            defaultUser = try userRepository.createDefaultUserIfNeeded()
        } catch {
            XCTFail("Error during default user creation: \(error)")
        }
    }
    
    func testFetchExercisesSuccess() throws {
        let context = viewContext
        
        let exercise = Exercise(context: context)
        exercise.id = UUID()
        exercise.exerciseCategory = .running
        exercise.date = Date()
        exercise.duration = 45
        exercise.intensity = 7
        exercise.user = defaultUser
        try context.save()
        
        let exerciseRepo = ExerciseRepository(context: context)
        let viewModel = ExerciseListViewModel(exerciseRepository: exerciseRepo)
        
        XCTAssertEqual(viewModel.exercises.count, 1)
        XCTAssertEqual(viewModel.exercises.first?.duration, 45)
        XCTAssertNil(viewModel.error)
    }
    
    func testFetchExercisesFailure() {
        let failingExerciseRepo = FailingExerciseRepository(context: viewContext)
        let viewModel = ExerciseListViewModel(exerciseRepository: failingExerciseRepo)
        
        XCTAssertNotNil(viewModel.error)
        if case let AppError.repositoryError(message)? = viewModel.error {
            XCTAssertEqual(message, "FailingExerciseRepository error")
        } else {
            XCTFail("Expected repositoryError")
        }
    }
    
    func testDeleteExerciseSuccess() throws {
        let context = viewContext
        
        let exerciseRepo = ExerciseRepository(context: context)
        let exercise = try exerciseRepo.createExercise(category: .football,
                                                         date: Date(),
                                                         duration: 30,
                                                         intensity: 6,
                                                         user: defaultUser)
        let viewModel = ExerciseListViewModel(exerciseRepository: exerciseRepo)
        XCTAssertEqual(viewModel.exercises.count, 1)
        
        viewModel.deleteExercise(exercise)
        XCTAssertEqual(viewModel.exercises.count, 0)
        XCTAssertNil(viewModel.error)
    }
    
    func testDeleteExerciseFailure() {
        let failingExerciseRepo = FailingExerciseRepository(context: viewContext)
        let viewModel = ExerciseListViewModel(exerciseRepository: failingExerciseRepo)
        
        let exercise = Exercise(context: viewContext)
        exercise.id = UUID()
        exercise.exerciseCategory = .running
        exercise.date = Date()
        exercise.duration = 30
        exercise.intensity = 6
        exercise.user = defaultUser
        try? viewContext.save()
        
        viewModel.deleteExercise(exercise)
        XCTAssertNotNil(viewModel.error)
        if case let AppError.repositoryError(message)? = viewModel.error {
            XCTAssertEqual(message, "FailingExerciseRepository error")
        } else {
            XCTFail("Expected repositoryError")
        }
    }
}
