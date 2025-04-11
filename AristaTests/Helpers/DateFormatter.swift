//
//  File.swift
//  AristaTests
//
//  Created by Elo on 11/04/2025.
//

import Foundation

extension DateFormatter {
    static var testFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm"
        return formatter
    }
}
