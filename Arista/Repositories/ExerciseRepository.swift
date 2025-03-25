//
//  ExerciseRepository.swift
//  Arista
//
//  Created by Elo on 20/03/2025.
//

import Foundation

protocol ExerciseRepository {
    func fetchAllExercises() throws -> [Exercise]
    func createExercise(category: ExerciseCategory,
                          date: Date,
                          duration: Int16,
                          intensity: Int16,
                          user: User) throws -> Exercise
    func deleteExercise(_ exercise: Exercise) throws
}
