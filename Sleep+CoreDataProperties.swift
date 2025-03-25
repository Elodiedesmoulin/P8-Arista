//
//  Sleep+CoreDataProperties.swift
//  Arista
//
//  Created by Elo on 19/03/2025.
//
//

import Foundation
import CoreData


extension Sleep {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sleep> {
        return NSFetchRequest<Sleep>(entityName: "Sleep")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var startDate: Date?
    @NSManaged public var duration: Int16
    @NSManaged public var quality: Int16
    @NSManaged public var user: User?

}

extension Sleep : Identifiable {

}
