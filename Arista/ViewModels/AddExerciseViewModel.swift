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
    @Published var error: AppError? = nil

    private let exerciseRepository: ExerciseRepository
    private let userRepository: UserRepository

    init(exerciseRepository: ExerciseRepository, userRepository: UserRepository) {
        self.exerciseRepository = exerciseRepository
        self.userRepository = userRepository
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm"
        self.startTime = formatter.string(from: Date())
    }

    func addExercise() -> Bool {
        guard let durationInt = Int16(duration) else {
            self.error = .invalidDuration
            return false
        }
        guard let intensityInt = Int16(intensity) else {
            self.error = .invalidIntensity
            return false
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm"
        guard let parsedDate = formatter.date(from: startTime) else {
            self.error = .invalidStartTime
            return false
        }
        
        do {
            guard let user = try userRepository.fetchSingleUser() else {
                self.error = .userNotFound
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
            self.error = .repositoryError(error.localizedDescription)
            return false
        }
    }
}
