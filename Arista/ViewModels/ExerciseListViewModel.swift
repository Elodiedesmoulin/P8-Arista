//
//  ExerciseListViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation

class ExerciseListViewModel: ObservableObject {
    @Published var exercises: [Exercise] = []
    @Published var error: AppError? = nil

    private let exerciseRepository: ExerciseRepository

    init(exerciseRepository: ExerciseRepository) {
        self.exerciseRepository = exerciseRepository
        fetchExercises()
    }

    func fetchExercises() {
        do {
            exercises = try exerciseRepository.fetchAllExercises()
        } catch {
            self.error = .repositoryError(error.localizedDescription)
            exercises = []
        }
    }

    func deleteExercise(_ exercise: Exercise) {
        do {
            try exerciseRepository.deleteExercise(exercise)
            fetchExercises()
        } catch {
            self.error = .repositoryError(error.localizedDescription)
        }
    }
}
