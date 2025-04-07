//
//  ExerciseListViewModelTests.swift
//  Arista
//
//  Created by Elo on 28/03/2025.
//


import XCTest
import CoreData
@testable import Arista

class ExerciseListViewModelTests: XCTestCase {
    
    var persistentContainer: NSPersistentContainer!
    
    override func setUp() {
        super.setUp()
        persistentContainer = PersistenceController(inMemory: true).container
    }
    
    override func tearDown() {
        persistentContainer = nil
        super.tearDown()
    }
    
    func testFetchExercisesSuccess() throws {
        let context = persistentContainer.viewContext
        // Crée un utilisateur
        let user = User(context: context)
        user.firstName = "Bob"
        user.lastName = "Marley"
        user.email = "bob@example.com"
        user.password = "reggae"
        try context.save()
        
        // Crée un exercice
        let exercise = Exercise(context: context)
        exercise.id = UUID()
        exercise.exerciseCategory = .running
        exercise.date = Date()
        exercise.duration = 45
        exercise.intensity = 7
        exercise.user = user
        try context.save()
        
        let exerciseRepo = ExerciseRepository(context: context)
        let viewModel = ExerciseListViewModel(exerciseRepository: exerciseRepo)
        
        XCTAssertEqual(viewModel.exercises.count, 1)
        XCTAssertEqual(viewModel.exercises.first?.duration, 45)
        XCTAssertNil(viewModel.error)
    }
    
    func testFetchExercisesFailure() {
        let failingExerciseRepo = FailingExerciseRepository(context: persistentContainer.viewContext)
        let viewModel = ExerciseListViewModel(exerciseRepository: failingExerciseRepo)
        
        XCTAssertNotNil(viewModel.error)
        if case let AppError.repositoryError(message)? = viewModel.error {
            XCTAssertEqual(message, "FailingExerciseRepository error")
        } else {
            XCTFail("Expected repositoryError")
        }
    }
    
    func testDeleteExerciseSuccess() throws {
        let context = persistentContainer.viewContext
        let user = User(context: context)
        user.firstName = "Carol"
        user.lastName = "King"
        user.email = "carol@example.com"
        user.password = "song"
        try context.save()
        
        let exerciseRepo = ExerciseRepository(context: context)
        let exercise = try exerciseRepo.createExercise(category: .football, date: Date(), duration: 30, intensity: 6, user: user)
        let viewModel = ExerciseListViewModel(exerciseRepository: exerciseRepo)
        XCTAssertEqual(viewModel.exercises.count, 1)
        
        viewModel.deleteExercise(exercise)
        XCTAssertEqual(viewModel.exercises.count, 0)
        XCTAssertNil(viewModel.error)
    }
    
    func testDeleteExerciseFailure() {
        let failingExerciseRepo = FailingExerciseRepository(context: persistentContainer.viewContext)
        let viewModel = ExerciseListViewModel(exerciseRepository: failingExerciseRepo)
        
        let context = persistentContainer.viewContext
        let user = User(context: context)
        user.firstName = "Test"
        user.lastName = "User"
        user.email = "test@example.com"
        user.password = "123"
        let dummyExercise = Exercise(context: context)
        dummyExercise.id = UUID()
        dummyExercise.exerciseCategory = .running
        dummyExercise.date = Date()
        dummyExercise.duration = 30
        dummyExercise.intensity = 6
        dummyExercise.user = user
        try? context.save()
        
        viewModel.deleteExercise(dummyExercise)
        XCTAssertNotNil(viewModel.error)
        if case let AppError.repositoryError(message)? = viewModel.error {
            XCTAssertEqual(message, "FailingExerciseRepository error")
        } else {
            XCTFail("Expected repositoryError")
        }
    }
}
