//
//  SleepHistoryViewModel.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import Foundation

struct SleepDisplay: Identifiable {
    let id: UUID
    let startDate: Date
    let duration: Int
    let quality: Int
}

class SleepHistoryViewModel: ObservableObject {
    @Published var sleepSessions: [SleepDisplay] = []

    private let sleepRepository: SleepRepository

    init(sleepRepository: SleepRepository) {
        self.sleepRepository = sleepRepository
        fetchSleepData()
    }

    func fetchSleepData() {
        do {
            let sessions = try sleepRepository.fetchAllSleepSessions()
            sleepSessions = sessions.map {
                SleepDisplay(
                    id: $0.id ?? UUID(),
                    startDate: $0.startDate ?? Date(),
                    duration: Int($0.duration),
                    quality: Int($0.quality)
                )
            }
        } catch {
            print("Error fetching sleep sessions: \(error)")
        }
    }
}
