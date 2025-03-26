//
//  ExerciseCategory.swift
//  Arista
//
//  Created by Elo on 19/03/2025.
//

import Foundation

enum ExerciseCategory: String, CaseIterable, Identifiable {
    case running = "Running"
    case natation = "Natation"
    case football = "Football"
    case marche = "Marche"
    case cyclisme = "Cyclisme"
    
    var id: String { self.rawValue }
}
