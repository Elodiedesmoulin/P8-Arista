//
//  ExerciseRepositoryTests.swift
//  Arista
//
//  Created by Elo on 28/03/2025.
//


import XCTest
import CoreData
@testable import Arista

class ExerciseRepositoryTests: XCTestCase {
    
    var persistentContainer: NSPersistentContainer!
    var exerciseRepo: ExerciseRepository!
    var userRepo: UserRepository!
    let date = Date()

    override func setUp() {
        super.setUp()
        persistentContainer = CoreDataTestStack.inMemoryPersistentContainer()
        exerciseRepo = ExerciseRepository(context: persistentContainer.viewContext)
        userRepo = UserRepository(context: persistentContainer.viewContext)
    }
    
    override func tearDown() {
        exerciseRepo = nil
        userRepo = nil
        persistentContainer = nil
        super.tearDown()
    }
    
    func testAddExercise_SavesCorrectAttributes() throws {
        let user = try userRepo.createDefaultUserIfNeeded()
        
        let exercise = try exerciseRepo.createExercise(category: .running,
                                                        date: date,
                                                        duration: 60,
                                                        intensity: 5,
                                                        user: user)
        XCTAssertNotNil(exercise)
        XCTAssertEqual(exercise.exerciseCategory, .running)
        XCTAssertEqual(exercise.duration, 60)
        XCTAssertEqual(exercise.intensity, 5)
        XCTAssertEqual(exercise.user, user)
        
        let exercises = try exerciseRepo.fetchAllExercises()
        XCTAssertTrue(exercises.contains(where: { $0.id == exercise.id }))
    }
    
    func testDeleteExercise() throws {
        let user = try userRepo.createDefaultUserIfNeeded()
        let exercise = try exerciseRepo.createExercise(category: .running,
                                                        date: date,
                                                        duration: 60,
                                                        intensity: 5,
                                                        user: user)
        var exercises = try exerciseRepo.fetchAllExercises()
        XCTAssertTrue(exercises.contains(where: { $0.id == exercise.id }))
        
        try exerciseRepo.deleteExercise(exercise)
        exercises = try exerciseRepo.fetchAllExercises()
        XCTAssertFalse(exercises.contains(where: { $0.id == exercise.id }))
    }
    
    func testExercisesAreSortedByDateDescending() throws {
        let user = try userRepo.createDefaultUserIfNeeded()
        _ = try exerciseRepo.createExercise(category: .running,
                                            date: date,
                                            duration: 30,
                                            intensity: 5,
                                            user: user)
        _ = try exerciseRepo.createExercise(category: .football,
                                            date: date.addingTimeInterval(-3600),
                                            duration: 45,
                                            intensity: 7,
                                            user: user)
        _ = try exerciseRepo.createExercise(category: .cyclisme,
                                            date: date.addingTimeInterval(3600),
                                            duration: 50,
                                            intensity: 6,
                                            user: user)
        
        let exercises = try exerciseRepo.fetchAllExercises()
        XCTAssertGreaterThan(exercises.first?.date ?? Date.distantPast, exercises.last?.date ?? Date.distantPast)
    }
}
