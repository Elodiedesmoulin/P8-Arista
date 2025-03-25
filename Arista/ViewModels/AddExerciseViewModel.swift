//
//  AddExerciseViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation

class AddExerciseViewModel: ObservableObject {
    @Published var selectedCategory: ExerciseCategory = .running 
    @Published var startTime: String = ""
    @Published var duration: String = ""
    @Published var intensity: String = ""
    @Published var createdExercise: Exercise?

    private let exerciseRepository: ExerciseRepository
    private let userRepository: UserRepository

    init(exerciseRepository: ExerciseRepository,
         userRepository: UserRepository) {
        self.exerciseRepository = exerciseRepository
        self.userRepository = userRepository
    }

    func addExercise() -> Bool {
        guard let durationInt = Int16(duration),
              let intensityInt = Int16(intensity) else {
            return false
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm"
        let parsedDate = formatter.date(from: startTime) ?? Date()

        do {
            guard let user = try userRepository.fetchSingleUser() else {
                return false
            }
            let newExercise = try exerciseRepository.createExercise(
                category: selectedCategory,
                date: parsedDate,
                duration: durationInt,
                intensity: intensityInt,
                user: user
            )
            self.createdExercise = newExercise
            return true
        } catch {
            print("Error adding exercise: \(error)")
            return false
        }
    }
}
