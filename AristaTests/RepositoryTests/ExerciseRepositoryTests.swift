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
        persistentContainer = PersistenceController(inMemory: true).container
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
        let user = try userRepo.ensureDefaultUserExists()
        
        let exercise = try exerciseRepo.createExercise(category: .running,
                                                        date: date,
                                                        duration: 60,
                                                        intensity: 5,
                                                        user: user)
        
        let fetchedExercise = try exerciseRepo.fetchAllExercises().first

        XCTAssertNotNil(fetchedExercise)
        XCTAssertEqual(fetchedExercise?.exerciseCategory, .running)
        XCTAssertEqual(fetchedExercise?.duration, 60)
        XCTAssertEqual(fetchedExercise?.intensity, 5)
        XCTAssertEqual(fetchedExercise?.user, user)
        XCTAssertEqual(fetchedExercise?.id, exercise.id)
    }
    
    func testDeleteExercise() throws {
        let user = try userRepo.ensureDefaultUserExists()
        let exercise = try exerciseRepo.createExercise(category: .running,
                                                        date: date,
                                                        duration: 60,
                                                        intensity: 5,
                                                        user: user)
        let fetchedExercise = try exerciseRepo.fetchAllExercises().first
        XCTAssertEqual(fetchedExercise?.id, exercise.id)

        try exerciseRepo.deleteExercise(exercise)
        let fetchedExercises = try exerciseRepo.fetchAllExercises()
        XCTAssertTrue(fetchedExercises.isEmpty)
    }
    
    func testExercisesAreSortedByDateDescending() throws {
        let user = try userRepo.ensureDefaultUserExists()
        let exerciseCurrentDate = try exerciseRepo.createExercise(category: .running,
                                            date: date,
                                            duration: 30,
                                            intensity: 5,
                                            user: user)
        let exercisePreviousDate = try exerciseRepo.createExercise(category: .football,
                                            date: date.addingTimeInterval(-3600),
                                            duration: 45,
                                            intensity: 7,
                                            user: user)
        let exerciseNextDate = try exerciseRepo.createExercise(category: .cyclisme,
                                            date: date.addingTimeInterval(3600),
                                            duration: 50,
                                            intensity: 6,
                                            user: user)
        
        let exercises = try exerciseRepo.fetchAllExercises()
        XCTAssertEqual(exercises.count, 3)
        XCTAssertEqual(exercises[0].id, exerciseNextDate.id)
        XCTAssertEqual(exercises[1].id, exerciseCurrentDate.id)
        XCTAssertEqual(exercises[2].id, exercisePreviousDate.id)
    }
}
