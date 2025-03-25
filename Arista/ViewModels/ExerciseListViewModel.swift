//
//  ExerciseListViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation

struct ExerciseDisplay: Identifiable {
    let id: UUID
    let category: String
    let date: Date
    let duration: Int
    let intensity: Int
}

class ExerciseListViewModel: ObservableObject {
    @Published var exercises: [ExerciseDisplay] = []

    private let exerciseRepository: ExerciseRepository

    init(exerciseRepository: ExerciseRepository) {
        self.exerciseRepository = exerciseRepository
        fetchExercises()
    }

    func fetchExercises() {
        do {
            let list = try exerciseRepository.fetchAllExercises()
            exercises = list.map {
                ExerciseDisplay(
                    id: $0.id ?? UUID(),
                    category: $0.exerciseCategory.rawValue, 
                    date: $0.date ?? Date(),
                    duration: Int($0.duration),
                    intensity: Int($0.intensity)
                )
            }
        } catch {
            print("Error fetching exercises: \(error)")
            exercises = []
        }
    }

    func deleteExercise(by id: UUID) {
        do {
            let list = try exerciseRepository.fetchAllExercises()
            if let exercise = list.first(where: { $0.id == id }) {
                try exerciseRepository.deleteExercise(exercise)
                fetchExercises()
            }
        } catch {
            print("Error deleting exercise: \(error)")
        }
    }
}
