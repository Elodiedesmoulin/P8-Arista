//
//  Exercise+CoreDataProperties.swift
//  Arista
//
//  Created by Elo on 19/03/2025.
//
//

import Foundation
import CoreData


extension Exercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @NSManaged public var id: UUID
    @NSManaged public var category: String
    @NSManaged public var date: Date
    @NSManaged public var duration: Int16
    @NSManaged public var intensity: Int16
    @NSManaged public var user: User

}

extension Exercise {
    var exerciseCategory: ExerciseCategory {
        get {
            if let categoryEnum = ExerciseCategory(rawValue: category) {
                return categoryEnum
            }
            return .running
        }
        set {
            self.category = newValue.rawValue
        }
    }
}

extension Exercise : Identifiable {

}
