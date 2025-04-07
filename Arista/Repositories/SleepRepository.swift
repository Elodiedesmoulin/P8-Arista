//
//  CoreDataSleepSessionRepository.swift
//  Arista
//
//  Created by Elo on 20/03/2025.
//

import Foundation
import CoreData

class SleepRepository {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchAllSleepSessions() throws -> [Sleep] {
        let request: NSFetchRequest<Sleep> = Sleep.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: false)]
        return try context.fetch(request)
    }
    
    func createSleepSession(startDate: Date, duration: Int16, quality: Int16, user: User) throws -> Sleep {
        let newSleep = Sleep(context: context)
        newSleep.id = UUID()
        newSleep.startDate = startDate
        newSleep.duration = duration
        newSleep.quality = quality
        newSleep.user = user
        try context.save()
        return newSleep
    }
    
    func deleteSleepSession(_ sleep: Sleep) throws {
        context.delete(sleep)
        try context.save()
    }
}
