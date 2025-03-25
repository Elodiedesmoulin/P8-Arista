//
//  UserRepository.swift
//  Arista
//
//  Created by Elo on 20/03/2025.
//

import Foundation

protocol UserRepository {
    func fetchSingleUser() throws -> User?
    func createDefaultUserIfNeeded() throws -> User
}
