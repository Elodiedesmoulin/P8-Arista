//
//  User+CoreDataProperties.swift
//  Arista
//
//  Created by Elo on 19/03/2025.
//
//

import Foundation
import CoreData

extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var firstName: String
    @NSManaged public var lastName: String
    @NSManaged public var email: String
    @NSManaged public var password: String
    @NSManaged public var exercises: NSSet?
    @NSManaged public var sleeps: NSSet?

}

extension User {

    @objc(addExercisesObject:)
    @NSManaged public func addToExercises(_ value: Exercise)

    @objc(removeExercisesObject:)
    @NSManaged public func removeFromExercises(_ value: Exercise)

    @objc(addExercises:)
    @NSManaged public func addToExercises(_ values: NSSet)

    @objc(removeExercises:)
    @NSManaged public func removeFromExercises(_ values: NSSet)

}

extension User {

    @objc(addSleepsObject:)
    @NSManaged public func addToSleeps(_ value: Sleep)

    @objc(removeSleepsObject:)
    @NSManaged public func removeFromSleeps(_ value: Sleep)

    @objc(addSleeps:)
    @NSManaged public func addToSleeps(_ values: NSSet)

    @objc(removeSleeps:)
    @NSManaged public func removeFromSleeps(_ values: NSSet)

}

extension User : Identifiable {

}
