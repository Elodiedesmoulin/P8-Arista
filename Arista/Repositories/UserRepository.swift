//
//  CoreDataUserRepository.swift
//  Arista
//
//  Created by Elo on 20/03/2025.
//

import Foundation
import CoreData

class UserRepository {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchSingleUser() throws -> User? {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.fetchLimit = 1
        let users = try context.fetch(request)
        return users.first
    }

    func ensureDefaultUserExists() throws -> User {
        if let existingUser = try fetchSingleUser() {
            return existingUser
        } else {
            let newUser = User(context: context)
            newUser.firstName = "John"
            newUser.lastName = "Smith"
            newUser.email = "john.smith@example.com"
            newUser.password = "1234"
            try context.save()
            return newUser
        }
    }
}
