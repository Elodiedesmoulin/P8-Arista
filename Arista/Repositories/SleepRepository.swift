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

    func createDefaultSleepData(for user: User) throws {
        let existing = try fetchAllSleepSessions()
        if existing.isEmpty {
            let samples: [(Date, Int16, Int16)] = [
                (Date().addingTimeInterval(-86400 * 1), 7 * 60, 8),
                (Date().addingTimeInterval(-86400 * 2), 6 * 60, 5),
                (Date().addingTimeInterval(-86400 * 3), 8 * 60, 9)
            ]
            for (start, duration, quality) in samples {
                let session = Sleep(context: context)
                session.id = UUID()
                session.startDate = start
                session.duration = duration * 60
                session.quality = quality
                session.user = user
            }
            try context.save()
        }
    }
}
