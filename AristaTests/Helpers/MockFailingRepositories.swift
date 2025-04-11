//
//  MockFailingRepositories.swift
//  AristaTests
//
//  Created by Elo on 28/03/2025.
//

import Foundation
import CoreData
@testable import Arista

class FailingUserRepository: UserRepository {
    override func fetchSingleUser() throws -> User? {
        throw AppError.repositoryError("FailingUserRepository error")
    }
    
    override func ensureDefaultUserExists() throws -> User {
        throw AppError.repositoryError("FailingUserRepository error")
    }
}

class FailingExerciseRepository: ExerciseRepository {
    override func fetchAllExercises() throws -> [Exercise] {
        throw AppError.repositoryError("FailingExerciseRepository error")
    }
    
    override func createExercise(category: ExerciseCategory, date: Date, duration: Int16, intensity: Int16, user: User) throws -> Exercise {
        throw AppError.repositoryError("FailingExerciseRepository error")
    }
    
    override func deleteExercise(_ exercise: Exercise) throws {
        throw AppError.repositoryError("FailingExerciseRepository error")
    }
}

class FailingSleepRepository: SleepRepository {
    override func fetchAllSleepSessions() throws -> [Sleep] {
        throw AppError.repositoryError("FailingSleepRepository error")
    }
    override func createSleepSession(startDate: Date, duration: Int16, quality: Int16, user: User) throws -> Sleep {
        throw AppError.repositoryError("FailingSleepRepository error")
    }
    override func deleteSleepSession(_ sleep: Sleep) throws {
        throw AppError.repositoryError("FailingSleepRepository error")
    }
}
