//
//  AppError.swift
//  Arista
//
//  Created by Elo on 27/03/2025.
//

import Foundation

import Foundation

enum AppError: Error, LocalizedError, Equatable, Identifiable {
    case invalidDuration
    case invalidIntensity
    case invalidStartTime
    case userNotFound
    case repositoryError(String)
    
    var id: String { errorDescription ?? UUID().uuidString }
    
    var errorDescription: String? {
        switch self {
        case .invalidDuration:
            return "Invalid duration value."
        case .invalidIntensity:
            return "Invalid intensity value."
        case .invalidStartTime:
            return "Invalid start time value."
        case .userNotFound:
            return "User not found."
        case .repositoryError(let message):
            return message
        }
    }
}
