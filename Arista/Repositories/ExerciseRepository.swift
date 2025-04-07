//
//  CoreDataExerciseRepository.swift
//  Arista
//
//  Created by Elo on 20/03/2025.
//

import Foundation
import CoreData

class ExerciseRepository {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func
    fetchAllExercises() throws -> [Exercise] {
        let request: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        return try context.fetch(request)
    }

    func createExercise(category: ExerciseCategory,
                          date: Date,
                          duration: Int16,
                          intensity: Int16,
                          user: User) throws -> Exercise {
        let newExercise = Exercise(context: context)
        newExercise.id = UUID()
        newExercise.exerciseCategory = category
        newExercise.date = date
        newExercise.duration = duration
        newExercise.intensity = intensity
        newExercise.user = user
        try context.save()
        return newExercise
    }

    func deleteExercise(_ exercise: Exercise) throws {
        context.delete(exercise)
        try context.save()
    }
}
