//
//  SleepSessionRepository.swift
//  Arista
//
//  Created by Elo on 20/03/2025.
//


import Foundation

protocol SleepRepository {
        func fetchAllSleepSessions() throws -> [Sleep]
        func createDefaultSleepData(for user: User) throws
    }
